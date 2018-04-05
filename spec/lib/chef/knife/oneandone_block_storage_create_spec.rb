require 'spec_helper'
require 'oneandone_block_storage_create'

Chef::Knife::OneandoneBlockStorageCreate.load_deps

describe Chef::Knife::OneandoneBlockStorageCreate do
  subject { Chef::Knife::OneandoneBlockStorageCreate.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    subject.config[:name] = 'My-new-block-storage'
    subject.config[:description] = 'My-block-storage-description'
    subject.config[:size] = '20'
    subject.config[:server_id] = '638ED28205B1AFD7ADEF569C725DD85F'
    subject.config[:datacenter_id] = 'D0F6D8C8ED29D3036F94C27BBB7BAD36'
  end

  describe '#run' do
    it 'should output being created' do
      VCR.use_cassette('block_storage_create') do
        expect(subject).to receive(:puts).with(/being\screated$/)
        subject.run
      end
    end
  end
end
