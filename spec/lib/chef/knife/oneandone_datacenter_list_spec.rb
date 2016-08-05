require 'spec_helper'
require 'oneandone_datacenter_list'

Chef::Knife::OneandoneDatacenterList.load_deps

describe Chef::Knife::OneandoneDatacenterList do
  subject { Chef::Knife::OneandoneDatacenterList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('datacenter') do
        expect(subject).to receive(:puts).with(/^ID\s+Location\s+Country\sCode\s*$/)
        subject.run
      end
    end

    it 'should output the USA data center' do
      VCR.use_cassette('datacenter') do
        expect(subject).to receive(:puts).with(/\bUnited States of America\b/)
        subject.run
      end
    end
  end
end
