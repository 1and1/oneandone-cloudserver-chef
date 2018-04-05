require 'spec_helper'
require 'oneandone_ssh_key_list'

Chef::Knife::OneandoneSshKeyList.load_deps

describe Chef::Knife::OneandoneSshKeyList do
  subject { Chef::Knife::OneandoneSshKeyList.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
  end

  describe '#run' do
    it 'should output the column headers' do
      VCR.use_cassette('ssh_key_list') do
        expect(subject).to receive(:puts).with(/^ID\s+Name\s+Description\s+State\s+Servers\s+Md5\s+Public Key\s+Creation Date\s*$/)
        subject.run
      end
    end

    it 'should output test_chef_update' do
      VCR.use_cassette('ssh_key_list') do
        expect(subject).to receive(:puts).with(/My-new-ssh-key/)
        subject.run
      end
    end
  end
end
