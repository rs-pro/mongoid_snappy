# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_snappy/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_snappy"
  spec.version       = MongoidSnappy::VERSION
  spec.authors       = ["GlebTV"]
  spec.email         = ["glebtv@gmail.com"]
  spec.description   = %q{Mongoid Snappy}
  spec.summary       = %q{Allow string attributes in Mongoid to be compressed with Snappy}
  spec.homepage      = "https://github.com/rs-pro/mongoid_snappy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'snappy', '~> 0.0.8'
  spec.add_runtime_dependency 'mongoid', '>= 3.0'


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "database_cleaner", "~> 0.9.1"
  spec.add_development_dependency "mongoid-rspec", "~> 1.7.0"
  spec.add_development_dependency "faker", "~> 1.1.2"
end
