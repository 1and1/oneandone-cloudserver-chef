require 'spec_helper'
require 'oneandone_server_start'

Chef::Knife::OneandoneServerStart.load_deps

describe Chef::Knife::OneandoneServerStart do
  subject { Chef::Knife::OneandoneServerStart.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['951FEECF08A537A018B7D0285EAEEF6E']
  end

  describe '#run' do
    it 'should output starting' do
      VCR.use_cassette('server_start') do
        expect(subject).to receive(:puts).with(/starting/)
        subject.run
      end
    end
  end
end
