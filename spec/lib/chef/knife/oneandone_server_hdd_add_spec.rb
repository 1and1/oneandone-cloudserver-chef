require 'spec_helper'
require 'oneandone_server_hdd_add'

Chef::Knife::OneandoneServerHddAdd.load_deps

describe Chef::Knife::OneandoneServerHddAdd do
  subject { Chef::Knife::OneandoneServerHddAdd.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = [20]
    subject.config[:id] = '951FEECF08A537A018B7D0285EAEEF6E'
  end

  describe '#run' do
    it 'should output being added' do
      VCR.use_cassette('server_hdd_add') do
        expect(subject).to receive(:puts).with(/being\sadded$/)
        subject.run
      end
    end
  end
end
