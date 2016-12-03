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

# this tests the default recipe in the fixture cookbook 'ocserv_config' for custom
# resource testing purposes.
#
describe 'ocserv_config::default' do
  context 'When all attributes are defaults on CentOS 7.2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511', step_into: 'ocserv_config')
      runner.converge(described_recipe)
    end

    it 'sets dpd to 91' do
      expect(chef_run).to edit_replace_or_add('dpd').with(path: '/etc/ocserv/ocserv.conf', line: 'dpd = 91')
    end

    it 'creates ocserv_config dpd 91' do
      expect(chef_run).to create_ocserv_config('dpd').with_value('91')
    end
  end

  context 'When all attributes are defaults on CentOS 6.8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8', step_into: 'ocserv_config')
      runner.converge(described_recipe)
    end

    it 'sets dpd to 91' do
      expect(chef_run).to edit_replace_or_add('dpd').with(path: '/etc/ocserv/ocserv.conf', line: 'dpd = 91')
    end

    it 'creates ocserv_config dpd 91' do
      expect(chef_run).to create_ocserv_config('dpd').with_value('91')
    end
  end
end
