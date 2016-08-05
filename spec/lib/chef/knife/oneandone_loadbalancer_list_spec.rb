require 'spec_helper'
require 'oneandone_loadbalancer_list'

Chef::Knife::OneandoneLoadbalancerList.load_deps

describe Chef::Knife::OneandoneLoadbalancerList do
  subject { Chef::Knife::OneandoneLoadbalancerList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('loadbalancer_list') do
        header_regex = /^ID\s+Name\s+IP\sAddress\s+Method\s+State\s+Data\sCenter\s*$/
        expect(subject).to receive(:puts).with(header_regex)
        subject.run
      end
    end

    it 'should output testLB' do
      VCR.use_cassette('loadbalancer_list') do
        expect(subject).to receive(:puts).with(/\btestLB\b/)
        subject.run
      end
    end
  end
end
