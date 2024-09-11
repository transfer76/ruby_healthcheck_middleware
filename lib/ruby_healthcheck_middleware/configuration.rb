# frozen_string_literal: true

module RubyHealthcheckMiddleware
  # Class Configuration provides configuration initializer and params
  # validations
  class Configuration
    SETTERS = %i[
      database
      redis
      rabbitmq
      custom_services
      services_startup
      services_liveness
      services_readiness
      root_healthcheck_route
      endpoint_startup
      endpoint_liveness
      endpoint_readiness
    ].freeze

    DEFAULT_SERVICES = %i[database rabbitmq redis].freeze
    ROOT_HEALTHCHECK_ROUTE = '/sre'
    ENDPOINT_STARTUP = '/health'
    ENDPOINT_LIVENESS = '/liveness'
    ENDPOINT_READINESS = '/readiness'

    attr_reader(*RubyHealthcheckMiddleware::Configuration::SETTERS)

    # Initialize provides set up initial configuration
    def initialize(&block)
      instance_initializer.each { |instace_variable, value| instance_variable_set(:"@#{instace_variable}", value) }
      tap(&block) if block
    end

    # Provides checking of presence configuration for defined services
    def defined_services
      default_services = RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES.reject { |conn| public_send(conn).empty? }
      custom_array = RubyHealthcheckMiddleware.configuration.services_startup - DEFAULT_SERVICES
      default_services.concat(custom_array)
    end

    RubyHealthcheckMiddleware::Configuration::SETTERS.each do |method|
      define_method(:"#{method}=") do |argument|
        raise_unless(argument, __method__, valid_argument_type?(method, argument))
        instance_variable_set(:"@#{method}", argument)
      end
    end

    private

    def instance_initializer
      {
        database: {},
        redis: {},
        rabbitmq: {},
        custom_services: {},
        services_startup: RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES,
        services_liveness: RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES,
        services_readiness: RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES,
        root_healthcheck_route: RubyHealthcheckMiddleware::Configuration::ROOT_HEALTHCHECK_ROUTE,
        endpoint_startup: RubyHealthcheckMiddleware::Configuration::ENDPOINT_STARTUP,
        endpoint_liveness: RubyHealthcheckMiddleware::Configuration::ENDPOINT_LIVENESS,
        endpoint_readiness: RubyHealthcheckMiddleware::Configuration::ENDPOINT_READINESS
      }
    end

    def valid_argument_type?(method_name, argument)
      argument.is_a?(
        case method_name
        when :database, :redis, :rabbitmq, :custom_services then ::Hash
        when :services_startup, :services_liveness, :services_readiness then ::Array
        when :root_healthcheck_route, :endpoint_startup, :endpoint_liveness, :endpoint_readiness then ::String
        end
      )
    end

    def raise_unless(argument_context, argument_name, condition)
      raise RubyHealthcheckMiddleware::Error::ArgumentType.new(argument_context, argument_name) unless condition
    end
  end
end
