require 'spec_helper'
require 'oneandone_appliance_list'

Chef::Knife::OneandoneApplianceList.load_deps

describe Chef::Knife::OneandoneApplianceList do
  subject { Chef::Knife::OneandoneApplianceList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('appliance') do
        expect(subject).to receive(:puts).with(/:?ID\s+Name\s+Type\s+OS\s+Version\s+Architecture\n/)
        subject.run
      end
    end

    it 'should output Centos 7 appliance name' do
      VCR.use_cassette('appliance') do
        expect(subject).to receive(:puts).with(/\bcentos7-64std\b/)
        subject.run
      end
    end
  end
end
