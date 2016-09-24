#
# Cookbook Name:: ocserv
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'ocserv::install_ocserv'

firewall 'default' do
  action :disable
end

include_recipe 'simple_iptables::default'


