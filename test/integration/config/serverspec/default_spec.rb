require 'spec_helper'

describe 'when a node has converged ocserv::default' do
  describe file('/etc/ocserv/ocserv.conf') do
    it 'is a file and has the dpd, auth and dtls-psk keys configured' do
      expect(subject).to be_file
      expect(subject.content).to match(/dtls-psk = true/)
      expect(subject.content).to match(/auth = "certificate"/)
      expect(subject.content).to match(/dpd = 91/)
    end
  end
end
