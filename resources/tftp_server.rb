# frozen_string_literal: true

provides :tftp_server
unified_mode true

property :instance, String, name_property: true
property :packages, [String, Array],
         default: lazy {
           case node['platform_family']
           when 'debian'
             %w(tftpd-hpa)
           when 'rhel', 'fedora', 'amazon'
             %w(tftp-server)
           else
             raise Chef::Exceptions::UnsupportedAction, "tftp_server is not supported on #{node['platform_family']}"
           end
         },
         coerce: proc { |package_list| Array(package_list) },
         description: 'Package or packages that provide the TFTP server.'
property :directory, String, default: '/var/lib/tftpboot',
                             description: 'Directory served by the TFTP daemon.'
property :directory_owner, String, default: 'root',
                                   description: 'Owner for the TFTP root directory.'
property :directory_group, String, default: lazy { platform_family?('debian') ? 'nogroup' : 'root' },
                                   description: 'Group for the TFTP root directory.'
property :directory_mode, String, default: '0755',
                                  description: 'Mode for the TFTP root directory.'
property :username, String, default: 'tftp',
                            description: 'User used by the TFTP daemon on platforms that support it.'
property :address, String, default: '0.0.0.0:69',
                           description: 'Listen address used on Debian-family platforms.'
property :options, String, default: '--secure',
                           description: 'TFTP daemon options used on Debian-family platforms.'
property :service_name, String,
         default: lazy {
           case node['platform_family']
           when 'debian'
             'tftpd-hpa'
           when 'rhel', 'fedora', 'amazon'
             'tftp.socket'
           else
             raise Chef::Exceptions::UnsupportedAction, "tftp_server is not supported on #{node['platform_family']}"
           end
         },
                               description: 'Systemd service or socket unit to manage.'
property :config_file, [String, nil], default: lazy { platform_family?('debian') ? '/etc/default/tftpd-hpa' : nil },
                                     description: 'Debian-family tftpd-hpa environment file.'
property :config, Hash,
         default: lazy {
           {
             TFTP_USERNAME: username,
             TFTP_DIRECTORY: directory,
             TFTP_ADDRESS: address,
             TFTP_OPTIONS: options,
             RUN_DAEMON: 'yes',
             OPTIONS: '-s',
           }
         },
                       description: 'Debian-family tftpd-hpa environment values.'

default_action :create

action_class do
  def rhel_family_tftp?
    platform_family?('rhel', 'fedora', 'amazon')
  end
end

action :create do
  package new_resource.packages

  directory new_resource.directory do
    owner new_resource.directory_owner
    group new_resource.directory_group
    mode new_resource.directory_mode
    recursive true
    action :create
  end

  if platform_family?('debian')
    template new_resource.config_file do
      source 'tftp.erb'
      cookbook 'tftp'
      owner 'root'
      group 'root'
      mode '0644'
      variables(
        config_file: new_resource.config_file,
        conf: new_resource.config
      )
      notifies :restart, "service[#{new_resource.service_name}]"
    end
  elsif rhel_family_tftp?
    directory '/etc/systemd/system/tftp.service.d' do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
    end

    template '/etc/systemd/system/tftp.service.d/10-override.conf' do
      source '10-override.conf.erb'
      cookbook 'tftp'
      owner 'root'
      group 'root'
      mode '0644'
      variables(directory: new_resource.directory)
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
      notifies :restart, "service[#{new_resource.service_name}]"
    end

    execute 'systemctl daemon-reload' do
      action :nothing
    end
  end

  service new_resource.service_name do
    supports status: true, restart: true
    action [:enable, :start]
  end
end

action :delete do
  service new_resource.service_name do
    supports status: true, restart: true
    action [:stop, :disable]
  end

  if platform_family?('debian')
    file new_resource.config_file do
      action :delete
    end
  elsif rhel_family_tftp?
    file '/etc/systemd/system/tftp.service.d/10-override.conf' do
      action :delete
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
    end

    directory '/etc/systemd/system/tftp.service.d' do
      recursive true
      action :delete
    end

    execute 'systemctl daemon-reload' do
      action :nothing
    end
  end

  directory new_resource.directory do
    recursive true
    action :delete
  end

  package new_resource.packages do
    action :remove
  end
end
