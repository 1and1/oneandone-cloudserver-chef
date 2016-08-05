$LOAD_PATH.unshift File.expand_path('../../lib/chef/knife', __FILE__)

require 'oneandone'
require 'vcr'
require 'rspec'
require 'chef/knife'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('_DUMMY_TOKEN_') { ENV['ONEANDONE_API_KEY'] }

  c.before_record do |rec|
    filter_headers(rec, 'Strict-Transport-Security', '_DUMMY_SEC_')
    filter_headers(rec, 'Set-Cookie', '_DUMMY_COOKIE_')
  end
end

RSpec.configure do |c|
  c.before(:each) do
    Chef::Config.reset
  end
end

def filter_headers(interaction, pattern, placeholder)
  [interaction.request.headers, interaction.response.headers].each do |headers|
    sensitive_data = headers.select { |key| key.to_s.match(pattern) }
    sensitive_data.each do |key, _value|
      headers[key] = placeholder
    end
  end
end
