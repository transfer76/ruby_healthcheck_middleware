# frozen_string_literal: true

module Healthcheck
  module Middleware
    # Class Rack is rack middleware which provides integration with rack-app projects
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        case env['REQUEST_PATH']
        when startup_route then RubyHealthcheckMiddleware::ConnectionStatus::Organizer.call(:services_startup)
        when liveness_route then RubyHealthcheckMiddleware::ConnectionStatus::Organizer.call(:services_liveness)
        when readiness_route then RubyHealthcheckMiddleware::ConnectionStatus::Organizer.call(:services_readiness)
        else app.call(env)
        end
      end

      private

      attr_reader :app

      def configuration
        @configuration ||= RubyHealthcheckMiddleware.configuration
      end

      def startup_route
        "#{configuration.root_healthcheck_route}#{configuration.endpoint_startup}"
      end

      def liveness_route
        "#{startup_route}#{configuration.endpoint_liveness}"
      end

      def readiness_route
        "#{startup_route}#{configuration.endpoint_readiness}"
      end
    end
  end
end
