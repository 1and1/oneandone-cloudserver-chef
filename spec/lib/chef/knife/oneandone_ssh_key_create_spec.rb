require 'spec_helper'
require 'oneandone_ssh_key_create'

Chef::Knife::OneandoneSshKeyCreate.load_deps

describe Chef::Knife::OneandoneSshKeyCreate do
  subject { Chef::Knife::OneandoneSshKeyCreate.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    subject.config[:name] = 'My-new-ssh-key'
    subject.config[:description] = 'My-ssh-key-description'
  end

  describe '#run' do
    it 'should output being created' do
      VCR.use_cassette('ssh_key_create') do
        expect(subject).to receive(:puts).with(/being\screated$/)
        subject.run
      end
    end
  end
end
