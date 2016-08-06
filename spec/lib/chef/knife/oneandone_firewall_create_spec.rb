require 'spec_helper'
require 'oneandone_firewall_create'

Chef::Knife::OneandoneFirewallCreate.load_deps

describe Chef::Knife::OneandoneFirewallCreate do
  subject { Chef::Knife::OneandoneFirewallCreate.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    subject.config[:name] = 'knife-firewall'
    subject.config[:port_from] = '80,161'
    subject.config[:port_to] = '80,162'
    subject.config[:protocol] = 'TCP,UDP,IPSEC,ICMP'
  end

  describe '#run' do
    it 'should output being created' do
      VCR.use_cassette('firewall_create') do
        expect(subject).to receive(:puts).with(/being\screated$/)
        subject.run
      end
    end
  end
end
