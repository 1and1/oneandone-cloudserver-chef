require 'spec_helper'
require 'oneandone_mp_list'

Chef::Knife::OneandoneMpList.load_deps

describe Chef::Knife::OneandoneMpList do
  subject { Chef::Knife::OneandoneMpList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('mp') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+Email\s+State\s+Agent\s*$/)
        subject.run
      end
    end

    it 'should output default monitoring policy' do
      VCR.use_cassette('mp') do
        expect(subject).to receive(:puts).with(/\bDefault\sPolicy\b/)
        subject.run
      end
    end
  end
end
