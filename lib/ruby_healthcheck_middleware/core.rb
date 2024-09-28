# frozen_string_literal: true

# Core Provides require all dependencies of the gem
module RubyHealthcheckMiddleware
  require 'ruby_heathcheck_middleware/error/argument_type'
  require 'ruby_heathcheck_middleware/version'
  require 'ruby_heathcheck_middleware/configuration'
  require 'ruby_heathcheck_middleware/middleware/rack'
  require 'ruby_heathcheck_middleware/connection_status/orginizer'
  require 'ruby_heathcheck_middleware/connection_status/database'
  require 'ruby_heathcheck_middleware/connection_status/redis'
  require 'ruby_heathcheck_middleware/connection_status/rabbitmq'
end
