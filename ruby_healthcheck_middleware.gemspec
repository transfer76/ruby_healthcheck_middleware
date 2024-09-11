# frozen_string_literal: true

require_relative 'lib/ruby_healthcheck_middleware/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby_healthcheck_middleware'
  spec.version = RubyHealthcheckMiddleware::VERSION
  spec.authors = ['Volodymyr.Chernikov']
  spec.email = ['shina7667@gmail.com']
  spec.summary = %(ruby_healthcheck_middleware)
  spec.description = 'Healthcheck handler'
  spec.homepage = 'https://github.com/transfer76/ruby_healthcheck_middleware'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'bunny'
  spec.add_dependency 'rack', '>=2.2'
  spec.add_dependency 'sequel', '~> 5.24'

  spec.add_development_dependency 'allure-rspec', '= 2.20.0'
  spec.add_development_dependency 'bundler-audit', '~> 0.9.1'
  spec.add_development_dependency 'fakeredis', '~> 0.5.0'
  spec.add_development_dependency 'fasterer', '~> 0.10.1'
  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'json_matchers', '~> 0.11.1'
  spec.add_development_dependency 'pg', '~> 1.5', '>= 1.5.4'
  spec.add_development_dependency 'pry-byebug', '~> 3.10', '>= 3.10.1'
  spec.add_development_dependency 'rake', '~> 13.1'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.6.0'
  spec.add_development_dependency 'rspec-sonarqube-formatter', '~> 1.5'
  spec.add_development_dependency 'rubocop', '~> 1.57', '>= 1.57.2'
  spec.add_development_dependency 'rubocop-performance', '~> 1.19', '>= 1.19.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.25'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'test-unit', '~> 3.6', '>= 3.6.1'
end
