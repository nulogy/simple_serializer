# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_serializer"
  spec.version       = SimpleSerializer::VERSION
  spec.authors       = ["Sean Kirby"]
  spec.email         = ["seank@nulogy.com"]
  spec.summary       = %q{Very simple framelet for serializing/deserializing objects to hashes.}
  spec.description   = %q{Very simple framelet for serializing/deserializing objects to hashes.}
  spec.homepage      = "https://github.com/nulogy/simple_serializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
