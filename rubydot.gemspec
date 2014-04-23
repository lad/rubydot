# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubydot/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubydot'
  spec.version       = Rubydot::VERSION
  spec.authors       = ['Louis A. Dunne']
  spec.email         = ['louisadunne@gmail.com']
  spec.summary       = 'Generate dot based class diagrams from ruby source code'
  spec.homepage      = 'https://github.com/lad/rubydot'
  spec.license       = 'GPLv2'

  spec.files         = Dir['bin/**/*', 'lib/**/*.rb']
  spec.executables   = 'rubydot'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby_parser'
  spec.add_dependency 'docopt'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'bundler', '>= 1.6.0.pre.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
