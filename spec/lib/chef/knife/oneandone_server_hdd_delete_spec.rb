require 'spec_helper'
require 'oneandone_server_hdd_delete'

Chef::Knife::OneandoneServerHddDelete.load_deps

describe Chef::Knife::OneandoneServerHddDelete do
  subject { Chef::Knife::OneandoneServerHddDelete.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.config[:server_id] = '951FEECF08A537A018B7D0285EAEEF6E'
    subject.config[:disk_id] = '245C66678F0E45C63596D3F48EBCCFA0'
  end

  describe '#run' do
    it 'should output being deleted' do
      VCR.use_cassette('server_hdd_delete') do
        expect(subject).to receive(:puts).with(/being\sdeleted$/)
        subject.run
      end
    end
  end
end
