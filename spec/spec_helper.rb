# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require_relative 'support/config/simplecov'
require_relative '../lib/ruby_healthcheck_middleware'

rspec_custom = ::File.join(::File.dirname(__FILE__), 'support/**/*.rb')
::Dir[::File.expand_path(rspec_custom)].sort.each { |file| require file unless file[/\A.+_spec\.rb\z/] }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed
end
