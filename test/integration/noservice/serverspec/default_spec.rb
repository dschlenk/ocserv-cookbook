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

  it 'does not have ocserv service running or enabled' do
    expect(service('ocserv')).to_not be_enabled
    # init script returns 0 when no socket found
    expect(service('ocserv')).to_not be_running if os[:release].to_i != 6
  end

  describe file('/etc/ocserv/ocserv.conf') do
    it 'is a file and has the tcp, udp keys configured' do
      expect(subject).to be_file
      expect(subject.content).to match(/tcp-port = 443/)
      expect(subject.content).to match(/udp-port = 443/)
    end
  end
end
