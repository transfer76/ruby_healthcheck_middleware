# frozen_string_literal: true

require 'ruby_healthcheck_middleware/core'

# Root file of the gem
module RubyHealthcheckMiddleware
  class << self
    # Return configuration with validated params
    def configuration(&block)
      @configuration ||= begin
        return unless block

        RubyHealthcheckMiddleware::Configuration.new(&block).freez
      end
    end

    # Setup config params in service
    def configure(&block)
      configuration(&block)
    end

    # Resetconfiguration and return nil
    def reset_configuration!
      @configuration = nil
    end
  end
end
