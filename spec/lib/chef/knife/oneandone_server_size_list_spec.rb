require 'spec_helper'
require 'oneandone_server_size_list'

Chef::Knife::OneandoneServerSizeList.load_deps

describe Chef::Knife::OneandoneServerSizeList do
  subject { Chef::Knife::OneandoneServerSizeList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('server_size_list') do
        expect(subject).to receive(:puts)
          .with(/^ID\s+Name\s+RAM\s\(GB\)\s+Processor\sNo\.\s+Cores\sper\sProcessor\s+Disk\sSize\s\(GB\)\s*$/)
        subject.run
      end
    end

    it 'should output 5XL fixed server size' do
      VCR.use_cassette('server_size_list') do
        expect(subject).to receive(:puts).with(/\b5XL\b/)
        subject.run
      end
    end
  end
end
