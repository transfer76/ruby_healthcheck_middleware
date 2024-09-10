# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter
  ]
)

if ARGV.include?('RspecJunitFormatter') || ARGV.grep(/spec.\w+/).empty?
  SimpleCov.start do
    minimum_coverage(100)
    enable_coverage(:branch)
    add_filter(%w[/bin /spec /vendor])
    %w[
      lib
    ].each { |class_type| add_group(class_type.capitalize, class_type) }

    at_exit do
      SimpleCov.result.format!
      $stdout.print("UNIT (#{SimpleCov.result.covered_percent.floor(2)}%) covered\n")
    end
  end
end
