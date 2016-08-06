require 'spec_helper'
require 'oneandone_server_hdd_resize'

Chef::Knife::OneandoneServerHddResize.load_deps

describe Chef::Knife::OneandoneServerHddResize do
  subject { Chef::Knife::OneandoneServerHddResize.new }

  let(:api_key) { ENV['ONEANDONE_API_KEY'] }

  before :each do
    Chef::Config['knife']['oneandone_api_key'] = api_key
    allow(subject).to receive(:puts)
    subject.config[:server_id] = '951FEECF08A537A018B7D0285EAEEF6E'
    subject.config[:disk_id] = 'E181C3906D358642F5173400B7DCEC44'
    subject.config[:disk_size] = 60
  end

  describe '#run' do
    it 'should output resizing' do
      VCR.use_cassette('server_hdd_resize') do
        expect(subject).to receive(:puts).with(/resizing$/)
        subject.run
      end
    end
  end
end
