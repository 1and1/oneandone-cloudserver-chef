require 'spec_helper'
require 'oneandone_loadbalancer_delete'

Chef::Knife::OneandoneLoadbalancerDelete.load_deps

describe Chef::Knife::OneandoneLoadbalancerDelete do
  subject { Chef::Knife::OneandoneLoadbalancerDelete.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.name_args = ['C220C84E9B06913134245A5FC0849E44']
    # say yes to the delete confirmation message
    subject.config[:yes] = ''
  end

  describe '#run' do
    it 'should output being deleted' do
      VCR.use_cassette('loadbalancer_delete') do
        expect(subject).to receive(:puts).with(/being\sdeleted$/)
        subject.run
      end
    end
  end
end
