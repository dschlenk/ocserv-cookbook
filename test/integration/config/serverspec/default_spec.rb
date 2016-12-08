require 'spec_helper'

describe 'when a node has converged ocserv::default' do
  describe file('/etc/ocserv/ocserv.conf') do
    it 'is a file and has the dpd, auth, dtls-psk and router keys configured' do
      expect(subject).to be_file
      expect(subject.content).to match(/dtls-psk = true/)
      expect(subject.content).to match(/auth = "certificate"/)
      expect(subject.content).to match(/dpd = 91/)
      expect(subject.content).to include("route = 172.17.10.1\nroute = 172.17.13.1\nroute = 172.17.13.203")
    end
  end
end
