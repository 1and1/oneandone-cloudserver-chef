require 'spec_helper'
require 'oneandone_server_rename'

Chef::Knife::OneandoneServerRename.load_deps

describe Chef::Knife::OneandoneServerRename do
  subject { Chef::Knife::OneandoneServerRename.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.config[:id] = '951FEECF08A537A018B7D0285EAEEF6E'
    subject.config[:name] = 'new test'
    subject.config[:description] = 'new description'
  end

  describe '#run' do
    it 'should output updated' do
      VCR.use_cassette('server_rename') do
        expect(subject).to receive(:puts).with(/updated$/)
        subject.run
      end
    end
  end
end
