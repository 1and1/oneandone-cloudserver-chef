require 'spec_helper'
require 'oneandone_server_delete'

Chef::Knife::OneandoneServerDelete.load_deps

describe Chef::Knife::OneandoneServerDelete do
  subject { Chef::Knife::OneandoneServerDelete.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['951FEECF08A537A018B7D0285EAEEF6E']
    # say yes to the delete confirmation message
    subject.config[:yes] = ''
  end

  describe '#run' do
    it 'should output being deleted' do
      VCR.use_cassette('server_delete') do
        expect(subject).to receive(:puts).with(/being\sdeleted$/)
        subject.run
      end
    end
  end
end
