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
  let(:testfile) do
    'auth = "pam"
    tcp-port = 443
    udp-port = 443
    run-as-user = ocserv
    run-as-group = ocserv
    socket-file = ocserv.sock
    chroot-dir = /var/lib/ocserv
    isolate-workers = true
    max-clients = 16
    max-same-clients = 2
    keepalive = 32400
    dpd = 90
    mobile-dpd = 1800
    try-mtu-discovery = false
    server-cert = /etc/pki/ocserv/public/server.crt
    server-key = /etc/pki/ocserv/private/server.key
    ca-cert = /etc/pki/ocserv/cacerts/ca.crt
    cert-user-oid = 0.9.2342.19200300.100.1.1
    tls-priorities = "NORMAL:%SERVER_PRECEDENCE:%COMPAT:-VERS-SSL3.0"
    auth-timeout = 240
    min-reauth-time = 300
    max-ban-score = 50
    ban-reset-time = 300
    cookie-timeout = 300
    deny-roaming = false
    rekey-time = 172800
    rekey-method = ssl
    use-occtl = true
    pid-file = /var/run/ocserv.pid
    device = vpns
    predictable-ips = true
    default-domain = example.com
    ping-leases = false
    cisco-client-compat = true
    dtls-legacy = true
    user-profile = profile.xml'.gsub!(/^\s+/, '')
  end

  context 'When all attributes are defaults on CentOS 7.2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511', step_into: 'ocserv_config')
      runner.converge(described_recipe)
    end

    before do
      @file_content = testfile
      file_replacement
    end

    it 'creates ocserv_config dpd 91' do
      expect(chef_run).to create_ocserv_config('dpd').with_value('91')
    end

    it 'renders config file with routes' do
      expect(chef_run).to create_ocserv_config('route').with_value(['172.17.10.1', '172.17.13.1', '172.17.13.203'])
    end
  end

  context 'When all attributes are defaults on CentOS 6.8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8', step_into: 'ocserv_config')
      runner.converge(described_recipe)
    end

    before do
      @file_content = testfile
      file_replacement
    end

    it 'creates ocserv_config dpd 91' do
      expect(chef_run).to create_ocserv_config('dpd').with_value('91')
    end

    it 'renders config file with routes' do
      expect(chef_run).to create_ocserv_config('route').with_value(['172.17.10.1', '172.17.13.1', '172.17.13.203'])
    end
  end
end

def file_replacement
  allow(::File).to receive(:exist?).and_call_original
  allow(::File).to receive(:readlines).with(anything).and_call_original
  # allow(Tempfile).to receive(:new).and_call_original
  # Specific replacements
  allow(::File).to receive(:exist?).with('/etc/ocserv/ocserv.conf').and_return(true)
  allow(::File).to receive(:readlines).with('/etc/ocserv/ocserv.conf').and_return @file_content.split("\n")
  # fake_file = StringIO.open(@file_content)
  # fake_lstat = double
  # @file_content.each do |l|
  #  @temp_file << l
  # end
  newfile = double
  allow(::File).to receive(:open).and_call_original
  allow(::File).to receive(:open).with('/etc/ocserv/ocserv.conf', 'w').and_return(newfile)
  allow(newfile).to receive(:write).with(anything).and_return 1
  allow(newfile).to receive(:close)
  # allow(fake_file).to receive(:lstat).and_return(fake_lstat)
  # allow(fake_lstat).to receive(:uid).and_return(0)
  # allow(fake_lstat).to receive(:gid).and_return(0)
  # allow(fake_lstat).to receive(:mode).and_return(775)
  # allow(fake_file).to receive(:close) { fake_file.rewind }
  # allow(Tempfile).to receive(:new).with('foo').and_return(@temp_file)
  # allow(@temp_file).to receive(:close) { @temp_file.rewind }
  # allow(@temp_file).to receive(:unlink)
  # allow(FileUtils).to receive(:copy_file).with(@temp_file.path, 'file') { @file_content = @temp_file.read }
  # allow(FileUtils).to receive(:chown)
  # allow(FileUtils).to receive(:chmod)
  # missing_file = double
  # allow(::File).to receive(:exist?).with('missingfile').and_return(false)
  # allow(::File).to receive(:open).with('missingfile', 'w').and_return(missing_file)
  # allow(missing_file).to receive(:puts) { |line| @file_content << "#{line}\n" }
  # allow(missing_file).to receive(:close)
end
