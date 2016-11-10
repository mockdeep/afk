# frozen_string_literal: true
require_relative 'lib/afk/version'

Gem::Specification.new do |spec|
  spec.name          = 'afk'
  spec.version       = AFK::VERSION
  spec.authors       = ['Robert Fletcher']
  spec.email         = ['lobatifricha@gmail.com']

  spec.summary       = 'Export Trello todo lists for printing or offline use'
  spec.homepage      = 'https://github.com/mockdeep/afk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'ruby-trello', '~> 1.5'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.45.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.8.0'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'vcr', '~> 3.0'
end
