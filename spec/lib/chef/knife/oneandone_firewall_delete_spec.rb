require 'spec_helper'
require 'oneandone_firewall_delete'

Chef::Knife::OneandoneFirewallDelete.load_deps

describe Chef::Knife::OneandoneFirewallDelete do
  subject { Chef::Knife::OneandoneFirewallDelete.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['87B4E3234945F6ED928664EDA3E341C2']
    # say yes to the delete confirmation message
    subject.config[:yes] = ''
  end

  describe '#run' do
    it 'should output being deleted' do
      VCR.use_cassette('firewall_delete') do
        expect(subject).to receive(:puts).with(/being\sdeleted$/)
        subject.run
      end
    end
  end
end
