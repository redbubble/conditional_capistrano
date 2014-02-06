# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conditional_capistrano/version'

Gem::Specification.new do |spec|
  spec.name          = "conditional_capistrano"
  spec.version       = ConditionalCapistrano::VERSION
  spec.authors       = ["redbubble"]
  spec.email         = ["developers@redbubble.com"]
  spec.description   = %q{Conditionally schedule and execute capistrano tasks based on changes to specified paths}
  spec.summary       = %q{Execute capistrano task's only when certain path's have changed since the last deploy}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
