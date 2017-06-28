#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: tftp
# Recipe:: server
#
# Copyright:: 2011-2017, Chef Software, Inc.
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

unless %w(rhel fedora debian amazon).include?(node['platform_family'])
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
  include_recipe 'xinetd'
  # Using the xinetd provider to define the tftp service
  xinetd_service 'tftp' do
    # The main idea is to use the Mash from the node to create dynamically the
    # xinetd service
    node['tftp']['conf'].each do |k, v|
      send(k.to_sym, v)
    end
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
    notifies :restart, 'service[tftpd-hpa]'
  end

  service 'tftpd-hpa' do
    supports restart: true, status: true
    action [:enable, :start]
  end
end
