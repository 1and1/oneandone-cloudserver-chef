require 'spec_helper'
require 'oneandone_server_modify'

Chef::Knife::OneandoneServerModify.load_deps

describe Chef::Knife::OneandoneServerModify do
  subject { Chef::Knife::OneandoneServerModify.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['951FEECF08A537A018B7D0285EAEEF6E']
    subject.config[:cpu] = 2
    subject.config[:cores] = 2
    subject.config[:ram] = 2
  end

  describe '#run' do
    it 'should output being modified' do
      VCR.use_cassette('server_modify') do
        expect(subject).to receive(:puts).with(/being\smodified$/)
        subject.run
      end
    end
  end
end
