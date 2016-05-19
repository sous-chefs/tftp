name             'tftp'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures tftpd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.6.0'

%w( debian ubuntu fedora scientific centos redhat oracle).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/tftp' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/tftp/issues' if respond_to?(:issues_url)
%w(xinetd).each do |ck|
  depends ck
end
