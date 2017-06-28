#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: tftp
# Attributes:: default
#
# Copyright:: 2011-2017, Chef Software, Inc
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

default['tftp']['username'] = 'tftp'
default['tftp']['directory'] = '/var/lib/tftpboot'
default['tftp']['permissions'] = '0755'

case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  default['tftp']['owner']  = 'root'
  default['tftp']['group']  = 'root'
  default['tftp']['pkgs']   = %w(tftp-server)
  default['tftp']['conf'] = {
    socket_type: 'dgram',
    protocol: 'udp',
    wait: 'yes',
    user: 'root',
    server: '/usr/sbin/in.tftpd',
    server_args: "-s #{node['tftp']['directory']}",
    per_source: '11',
    cps: '100 2',
    flags: 'IPV4',
  }
when 'debian'
  default['tftp']['owner'] = 'root'
  default['tftp']['group'] = 'nogroup'
  default['tftp']['pkgs'] = %w(tftpd-hpa)
  default['tftp']['config_file'] = '/etc/default/tftpd-hpa'
  default['tftp']['conf'] = {
    TFTP_USERNAME: node['tftp']['username'],
    TFTP_DIRECTORY: node['tftp']['directory'],
    TFTP_ADDRESS: '0.0.0.0:69',
    TFTP_OPTIONS: '--secure',
    RUN_DAEMON: 'yes',
    OPTIONS: '-s',
  }
end
