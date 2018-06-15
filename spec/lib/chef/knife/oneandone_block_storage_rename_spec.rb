require 'spec_helper'
require 'oneandone_block_storage_rename'

Chef::Knife::OneandoneBlockStorageRename.load_deps

describe Chef::Knife::OneandoneBlockStorageRename do
  subject { Chef::Knife::OneandoneBlockStorageRename.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    # allow(subject).to receive(:puts)
    subject.config[:id] = '6AD2F180B7B666539EF75A02FE227084'
    subject.config[:name] = 'My-updated-block-storage'
    subject.config[:description] = 'My-updated-block-storage-description'
  end

  describe '#run' do
    it 'should output updated' do
      VCR.use_cassette('block_storage_rename') do
        expect(subject).to receive(:puts).with(/updated/)
        subject.run
      end
    end
  end
end
