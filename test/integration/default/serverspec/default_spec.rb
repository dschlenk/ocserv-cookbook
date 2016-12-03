require 'spec_helper'

describe 'when a node has converged ocserv::default' do
  it 'has package ocserv installed' do
    expect(package('ocserv')).to be_installed
  end

  it 'has udp and tcp ports 443 open' do
    if os[:release].to_i == 7
      expect(iptables).to have_rule('-A ocserv -p tcp -m tcp --dport 443 -m comment --comment ocserv -j ACCEPT')
      expect(iptables).to have_rule('-A ocserv -p udp -m udp --dport 443 -m comment --comment ocserv -j ACCEPT')
    else
      expect(iptables).to have_rule('-A ocserv -p tcp -m tcp --dport 443 -m comment --comment "ocserv" -j ACCEPT')
      expect(iptables).to have_rule('-A ocserv -p udp -m udp --dport 443 -m comment --comment "ocserv" -j ACCEPT')
    end
  end

  describe file('/etc/ocserv/ocserv.conf') do
    it 'is a file and has the tcp, udp and ipv4-network keys configured' do
      expect(subject).to be_file
      expect(subject.content).to match(%r{ipv4-network = 10.0.2.16/28})
      expect(subject.content).to match(/tcp-port = 443/)
      expect(subject.content).to match(/udp-port = 443/)
    end
  end

  it 'does have ocserv service running and enabled' do
    expect(service('ocserv')).to be_enabled
    expect(service('ocserv')).to be_running
  end
end
