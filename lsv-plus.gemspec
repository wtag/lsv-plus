# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lsv_plus/version'

Gem::Specification.new do |spec|
  spec.name          = 'lsv-plus'
  spec.version       = LSVplus::VERSION
  spec.authors       = ['Raffael Schmid']
  spec.email         = ['raffael.schmid@welltravel.com']
  spec.summary       = 'Gem to create LSV+ files'
  spec.homepage      = 'https://github.com/wtag/lsv-plus'
  spec.license       = 'MIT'
  spec.description   = 'Create a LSV+ file which can be uploaded to your bank.'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'
end
