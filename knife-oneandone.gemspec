lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-oneandone/version'

Gem::Specification.new do |spec|
  spec.name          = 'knife-oneandone'
  spec.version       = Knife::Oneandone::VERSION
  spec.authors       = ['Nurfet Becirevic']
  spec.email         = ['nurfet@stackpointcloud.com']

  spec.summary       = 'Chef Knife plugin for 1&1 Cloud server'
  spec.description   = 'Official Chef Knife plugin for managing 1&1 Cloud servers'
  spec.homepage      = 'https://github.com/1and1/oneandone-cloudserver-chef'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency '1and1', '~> 1.2'
  spec.add_runtime_dependency 'chef', '~> 12'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.24'
end
