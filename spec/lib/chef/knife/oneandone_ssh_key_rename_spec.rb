require 'spec_helper'
require 'oneandone_ssh_key_rename'

Chef::Knife::OneandoneSshKeyRename.load_deps

describe Chef::Knife::OneandoneSshKeyRename do
  subject { Chef::Knife::OneandoneSshKeyRename.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    # allow(subject).to receive(:puts)
    subject.config[:id] = '951FEECF08A537A018B7D0285EAEEF6E'
    subject.config[:name] = 'My-updated-ssh-key'
    subject.config[:description] = 'My-updated-ssh-key-description'
  end

  describe '#run' do
    it 'should output updated' do
      VCR.use_cassette('ssh_key_rename') do
        expect(subject).to receive(:puts).with(/updated/)
        subject.run
      end
    end
  end
end
