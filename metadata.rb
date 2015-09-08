name             "tftp"
maintainer       "Chef Software, Inc."
maintainer_email "cookbooks@chef.io"
license          "Apache 2.0"
description      "Installs/Configures tftpd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.0"

%w{ debian ubuntu fedora scientific centos redhat oracle}.each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/tftp' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/tftp/issues' if respond_to?(:issues_url)


attribute "tftp/username",
  :display_name => "tftp user",
  :default => "tftp"

attribute "tftp/directory",
  :display_name => "tftp directory",
  :description => "Directory to be shared via tftp.",
  :default => "/var/lib/tftpboot"

attribute "tftp/address",
  :display_name => "tftp address",
  :default => "0.0.0.0:69"

attribute "tftp/tftp_options",
  :display_name => "tftp tftp_options",
  :default => "--secure"

attribute "tftp/options",
  :display_name => "tftp options",
  :default => "-s"
