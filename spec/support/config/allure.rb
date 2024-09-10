# frozen_string_literal: true

require 'allure-rspec'

AllureRspec.configure do |config|
  config.results_directory = './allure-results/'
  config.clean_results_directory = true
  config.logging_level = Logger::INFO
end

RSpec.configure do |config|
  config.add_formatter(AllureRspecFormatter)
  config.add_formatter('documentation')
end
