#
# Cookbook Name:: ocserv
# Recipe:: install_ocserv
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'epel-release' do
  action :install
end

package 'ocserv' do
  action :install
end


