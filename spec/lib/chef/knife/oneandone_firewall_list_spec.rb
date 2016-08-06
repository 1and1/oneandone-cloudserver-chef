require 'spec_helper'
require 'oneandone_firewall_list'

Chef::Knife::OneandoneFirewallList.load_deps

describe Chef::Knife::OneandoneFirewallList do
  subject { Chef::Knife::OneandoneFirewallList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('firewall_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+State\s*$/)
        subject.run
      end
    end

    it 'should output Windows' do
      VCR.use_cassette('firewall_list') do
        expect(subject).to receive(:puts).with(/\bWindows\b/)
        subject.run
      end
    end
  end
end
