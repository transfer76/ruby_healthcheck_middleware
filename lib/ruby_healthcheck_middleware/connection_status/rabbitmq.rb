# frozen_string_literal: true

require 'bunny'

module RubyHealthcheckMiddlewar
  module ConnectionStatus
    # Class Rabbitmq provides checking of RabbitMq connection health status
    class Rabbitmq
      def self.call(params)
        Bunny.new(params[:url]).start.status.eql?(:open)
      rescue Bunny::NetworkFailure
        false
      end
    end
  end
end
