require 'spec_helper'
require 'oneandone_block_storage_list'

Chef::Knife::OneandoneBlockStorageList.load_deps

describe Chef::Knife::OneandoneBlockStorageList do
  subject { Chef::Knife::OneandoneBlockStorageList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('block_storage_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+Size\s+State\s+Datacenter\s+Server\sID\s+Server\sName\s*$/)
        subject.run
      end
    end

    it 'should output test_chef_update' do
      VCR.use_cassette('block_storage_list') do
        expect(subject).to receive(:puts).with(/chef-blk-update/)
        subject.run
      end
    end
  end
end
