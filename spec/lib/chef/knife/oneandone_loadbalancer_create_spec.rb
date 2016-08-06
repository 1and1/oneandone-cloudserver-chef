require 'spec_helper'
require 'oneandone_loadbalancer_create'

Chef::Knife::OneandoneLoadbalancerCreate.load_deps

describe Chef::Knife::OneandoneLoadbalancerCreate do
  subject { Chef::Knife::OneandoneLoadbalancerCreate.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    subject.config[:name] = 'testLB'
    subject.config[:description] = 'lb test'
    subject.config[:method] = 'LEAST_CONNECTIONS'
    subject.config[:health_check] = 'NONE'
    subject.config[:persistence] = true
    subject.config[:persistence_int] = 1000
    subject.config[:port_balancer] = '80,161'
    subject.config[:port_server] = '8080,161'
    subject.config[:protocol] = 'TCP,UDP'
  end

  describe '#run' do
    it 'should output being created' do
      VCR.use_cassette('loadbalancer_create') do
        expect(subject).to receive(:puts).with(/being\screated$/)
        subject.run
      end
    end
  end
end
