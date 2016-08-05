require 'spec_helper'
require 'oneandone_ip_list'

Chef::Knife::OneandoneIpList.load_deps

describe Chef::Knife::OneandoneIpList do
  subject { Chef::Knife::OneandoneIpList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('ip') do
        expect(subject).to receive(:puts).with(/^ID\s+IP\sAddress\s+DHCP\s+State\s+Data\sCenter\s+Assigned\sTo\s*$/)
        subject.run
      end
    end

    it 'should output v4 IPs' do
      VCR.use_cassette('ip') do
        expect(subject).to receive(:puts).with(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)
        subject.run
      end
    end
  end
end
