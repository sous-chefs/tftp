#
# Copyright 2013, Opscode, Inc.
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

require File.expand_path('../support/helpers', __FILE__)

describe 'tftp_test::default' do
  include Helpers::TftpTest

  # package
  it 'installs the proper tftp package' do
    if node['platform_family'].eql?('debian')
      package('tftpd-hpa').must_be_installed
    elsif node['platform_family'].eql?('rhel')
      package('tftp-server').must_be_installed
    end
  end

  # service
  it 'enables & starts the tftp service' do
    if node['platform_family'].eql?('debian')
      service('tftpd-hpa').must_be_enabled
      service('in.tftpd').must_be_running
    elsif node['platform_family'].eql?('rhel')
      service('xinetd').must_be_enabled
      service('xinetd').must_be_running
    end
  end

  # directory
  it 'enables & starts the tftp service' do
    if node['platform_family'].eql?('debian')
      directory(node['tftp']['directory']).must_have(:mode, '755').with(:owner, 'root').and(:group, 'root')
    elsif node['platform_family'].eql?('rhel')
      directory(node['tftp']['directory']).must_have(:mode, '755').with(:owner, 'nobody').and(:group, 'nobody')
    end
  end

  # template
  it 'has the correct config files' do
    if node['platform_family'].eql?('debian')
      file('/etc/default/tftpd-hpa').must_have(:mode, '644').with(:owner, 'root').and(:group, 'root')
    elsif node['platform_family'].eql?('rhel')
      file('/etc/xinetd.d/tftp').must_have(:mode, '644').with(:owner, 'root').and(:group, 'root')
    end
  end

end
