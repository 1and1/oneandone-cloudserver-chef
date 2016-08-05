require 'spec_helper'
require 'oneandone_server_list'

Chef::Knife::OneandoneServerList.load_deps

describe Chef::Knife::OneandoneServerList do
  subject { Chef::Knife::OneandoneServerList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('server_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+State\s+Data\sCenter\s*$/)
        subject.run
      end
    end

    it 'should output test-test server' do
      VCR.use_cassette('server_list') do
        expect(subject).to receive(:puts).with(/\btest-test\b/)
        subject.run
      end
    end
  end
end
