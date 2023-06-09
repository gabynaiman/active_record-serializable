# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/serializable/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record-serializable'
  spec.version       = ActiveRecord::Serializable::VERSION
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']
  spec.summary       = 'Extension for ActiveRecord to get serializable and marshalizable models using Rasti::Model'
  spec.description   = 'Extension for ActiveRecord to get serializable and marshalizable models using Rasti::Model'
  spec.homepage      = 'https://github.com/gabynaiman/active_record-serializable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '~> 4.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.0'
  spec.add_runtime_dependency 'rasti-model', '~> 2.0'
  spec.add_runtime_dependency 'bigdecimal', '~> 1.0'

  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'minitest', '~> 5.0', '< 5.11'
  spec.add_development_dependency 'minitest-colorin', '~> 0.1'
  spec.add_development_dependency 'minitest-line', '~> 0.6'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
end