#
# Cookbook Name:: ocserv
# Recipe:: install_ocserv
#
# Copyright 2016, ConvergeOne Holding Corp.
# License:: Apache License, Version 2.0
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

include_recipe 'yum-epel::default'
ocserv_dest = nil
if node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7.0 && node['kernel']['machine'] == 'x86_64'
  ocserv_pkg = "ocserv-#{node['ocserv']['version']}.x86_64.rpm"
  ocserv_dest = "#{Chef::Config[:file_cache_path]}/#{ocserv_pkg}"
  cookbook_file ocserv_dest do
    source ocserv_pkg
  end
end

package 'ocserv' do
  source ocserv_dest if ocserv_dest
  action :install
end
service_actions = [:enable, :start]
if node['ocserv']['config']['ipv4-network']
  ocserv_config 'ipv4-network' do
    value node['ocserv']['config']['ipv4-network']
  end
elsif node['ocserv']['config']['ipv6-network']
  ocserv_config 'ipv6-network' do
    value node['ocserv']['config']['ipv6-network']
  end
else
  Chef::Log.warn('Neither node[\'ocserv\'][\'ipv4-network\'] nor node[\'ocserv\'][\'ipv6-network\'] attributes were defined, not starting service.')
  service_actions = :nothing
end

service 'ocserv' do
  action service_actions
  supports status: true, restart: true, reload: true, stop: true, start: true
end
