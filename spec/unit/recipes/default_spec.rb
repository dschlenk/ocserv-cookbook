#
# Cookbook Name:: ocserv
# Spec:: default
#
# Copyright (c) 2016 ConvergeOne Holding Corp.
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

require 'spec_helper'

describe 'ocserv::default' do
  context 'When all attributes are defaults on CentOS 7.2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
      runner.converge(described_recipe)
    end

    it 'includes install_ocserv, firewalld::disable, simple_iptables recipes' do
      expect(chef_run).to include_recipe('ocserv::install_ocserv')
      expect(chef_run).to include_recipe('firewalld::disable')
      expect(chef_run).to include_recipe('simple_iptables::default')
    end

    it 'does not enable or start ocserv service' do
      expect(chef_run).to_not enable_service('ocserv')
      expect(chef_run).to_not start_service('ocserv')
    end
  end

  context 'When an IPv4 network set in attributes on CentOS 7.2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') do |node|
        node.default['ocserv']['config']['ipv4-network'] = '10.0.2.16/28'
      end
      runner.converge(described_recipe)
    end

    it 'includes install_ocserv, firewalld::disable, simple_iptables recipes' do
      expect(chef_run).to include_recipe('ocserv::install_ocserv')
      expect(chef_run).to include_recipe('firewalld::disable')
      expect(chef_run).to include_recipe('simple_iptables::default')
    end

    it 'enables and starts ocserv service' do
      expect(chef_run).to enable_service('ocserv')
      expect(chef_run).to start_service('ocserv')
    end
  end

  context 'When all attributes are defaults on CentOS 6.8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8')
      runner.converge(described_recipe)
    end

    it 'includes install_ocserv, simple_iptables recipes' do
      expect(chef_run).to include_recipe('ocserv::install_ocserv')
      expect(chef_run).to include_recipe('simple_iptables::default')
    end

    it 'replaces crappy init script' do
      expect(chef_run).to create_cookbook_file('/etc/init.d/ocserv')
    end

    it 'does not enable or start ocserv service' do
      expect(chef_run).to_not enable_service('ocserv')
      expect(chef_run).to_not start_service('ocserv')
    end
  end

  context 'When an IPv4 network is defined in attributes on CentOS 6.8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8') do |node|
        node.default['ocserv']['config']['ipv4-network'] = '10.0.2.16/28'
      end
      runner.converge(described_recipe)
    end

    it 'includes install_ocserv, simple_iptables recipes' do
      expect(chef_run).to include_recipe('ocserv::install_ocserv')
      expect(chef_run).to include_recipe('simple_iptables::default')
    end

    it 'replaces crappy init script' do
      expect(chef_run).to create_cookbook_file('/etc/init.d/ocserv')
    end

    it 'enables and starts ocserv service' do
      expect(chef_run).to enable_service('ocserv')
      expect(chef_run).to start_service('ocserv')
    end
  end
end
