#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: tftp
# Recipe:: server
#
# Copyright:: 2011-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unless platform_family?('rhel', 'fedora', 'debian', 'amazon')
  Chef::Log.warn("#{cookbook_name}::#{recipe_name} recipe is not supported on #{node['platform_family']}")
  return
end

package node['tftp']['pkgs']

directory node['tftp']['directory'] do
  owner node['tftp']['owner']
  group node['tftp']['group']
  mode node['tftp']['permissions']
  recursive true
  action :create
end

case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  directory '/etc/systemd/system/tftp.service.d'

  template '/etc/systemd/system/tftp.service.d/10-override.conf' do
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    notifies :restart, 'service[tftpd]'
  end

  execute 'systemctl daemon-reload' do
    action :nothing
  end
when 'debian'
  template node['tftp']['config_file'] do
    source 'tftp.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      config_file: node['tftp']['config_file'],
      conf: node['tftp']['conf']
    )
    notifies :restart, 'service[tftpd]'
  end
end

service 'tftpd' do
  service_name node['tftp']['service_name']
  action [:enable, :start]
end
