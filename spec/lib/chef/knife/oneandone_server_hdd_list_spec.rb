require 'spec_helper'
require 'oneandone_server_hdd_list'

Chef::Knife::OneandoneServerHddList.load_deps

describe Chef::Knife::OneandoneServerHddList do
  subject { Chef::Knife::OneandoneServerHddList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['951FEECF08A537A018B7D0285EAEEF6E']
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('server_hdd_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Size\s\(GB\)\s+Main\s*$/)
        subject.run
      end
    end

    it 'should output true for main HDD' do
      VCR.use_cassette('server_hdd_list') do
        expect(subject).to receive(:puts).with(/\btrue\b/)
        subject.run
      end
    end
  end
end
