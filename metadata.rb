name             'tftp'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'Installs/Configures tftpd'
version          '3.0.1'

%w( amazon debian ubuntu fedora scientific centos redhat oracle).each do |os|
  supports os
end

depends 'xinetd'

source_url 'https://github.com/chef-cookbooks/tftp'
issues_url 'https://github.com/chef-cookbooks/tftp/issues'
chef_version '>= 12.15'
