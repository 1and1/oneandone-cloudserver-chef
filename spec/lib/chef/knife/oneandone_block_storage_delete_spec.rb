require 'spec_helper'
require 'oneandone_block_storage_delete'

Chef::Knife::OneandoneBlockStorageDelete.load_deps

describe Chef::Knife::OneandoneBlockStorageDelete do
  subject { Chef::Knife::OneandoneBlockStorageDelete.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['6AD2F180B7B666539EF75A02FE227085']
    # say yes to the delete confirmation message
    subject.config[:yes] = ''
  end

  describe '#run' do
    it 'should output being deleted' do
      VCR.use_cassette('block_storage_delete') do
        expect(subject).to receive(:puts).with(/deleted/)
        subject.run
      end
    end
  end
end
