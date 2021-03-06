#
# Cookbook Name:: ocserv
# Recipe:: default
#
# Copyright 2016, ConvergeOne Holdings Corp.
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

include_recipe 'ocserv::install_ocserv'
if node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7.0
  include_recipe 'firewalld::disable'
end
include_recipe 'simple_iptables::default'

node['ocserv']['config'].each do |k, v|
  ocserv_config k do
    value v.to_s
  end
end

simple_iptables_rule 'ocserv' do
  rule ["--proto tcp --dport #{node['ocserv']['config']['tcp-port']}",
        "--proto udp --dport #{node['ocserv']['config']['udp-port']}"]
  jump 'ACCEPT'
end
