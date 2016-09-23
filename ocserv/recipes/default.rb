#
# Cookbook Name:: ocserv
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'epel-release' do
  action :install
end

package 'openvpn' do
  action :install
end
