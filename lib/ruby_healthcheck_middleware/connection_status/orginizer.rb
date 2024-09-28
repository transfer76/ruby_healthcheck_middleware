# frozen_string_literal: true

require 'json'
require 'securerandom'

module RubyHealthcheckMiddlewar
  module ConnectionStatus
    # Class Organizer provides checking services
    class Organizer
      CONTENT_TYPE_HEADER = { 'Content-Type' => 'application/json' }.freeze
      JSONAPI_RESPONSE_TYPE = 'application-healthcheck'
      SUCCESS_STATUS = 200
      FAILURE_STATUS = 503

      class << self
        def call(services_to_check)
          [response_status(services_to_check), { **CONTENT_TYPE_HEADER }, [response_jsonapi(services_to_check)]]
        end

        private

        def configuration
          @configuration ||= RubyHealthcheckMiddleware.configuration
        end

        # rubocop:disable Metrics/AbcSize
        def service_result(services_to_check)
          (configuration.defined_services & configuration.public_send(services_to_check)).each_with_object({}) do |service_name, response|
            response[service_name] =
              case service_name
              when *RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES
                RubyHealthcheckMiddleware::ConnectionStatus.const_get(service_name.to_s.capitalize).call(configuration.public_send(service_name))
              else
                configuration.custom_services[service_name]&.call
              end
          end
        end
        # rubocop:enable Metrics/AbcSize

        def response_jsonapi(services_to_check)
          {
            data: {
              id: ::SecureRandom.uuid,
              type: RubyHealthcheckMiddleware::ConnectionStatus::Organizer::JSONAPI_RESPONSE_TYPE,
              attributes: service_result(services_to_check)
            }
          }.to_json
        end

        def response_status(services_to_check)
          service_result(services_to_check).values.all? ? SUCCESS_STATUS : FAILURE_STATUS
        end
      end
    end
  end
end
