require 'spec_helper'
require 'oneandone_server_create'

Chef::Knife::OneandoneServerCreate.load_deps

describe Chef::Knife::OneandoneServerCreate do
  subject { Chef::Knife::OneandoneServerCreate.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    subject.config[:name] = 'test-test'
    subject.config[:appliance_id] = 'CF8318BDB7EFE797C9C769272AAA5F5C'
    subject.config[:fixed_size_id] = '65929629F35BBFBA63022008F773F3EB'
    subject.config[:datacenter_id] = '5091F6D8CBFEF9C26ACE957C652D5D49'
    subject.config[:wait] = false
  end

  describe '#run' do
    it 'should output being deployed' do
      VCR.use_cassette('server_create') do
        expect(subject).to receive(:puts).with(/being\sdeployed$/)
        subject.run
      end
    end
  end
end
