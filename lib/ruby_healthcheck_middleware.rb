# frozen_string_literal: true

require 'ruby_healthcheck_middleware/core'

# Root file of the gem
module RubyHealthcheckMiddleware
  class << self
    def configuration(&block)
      @configuration ||= begin
        return unless block

        RubyHealthcheckMiddleware::Configuration.new(&block).freez
      end
    end

    def configure(&block)
      configuration(&block)
    end

    def reset_configuration!
      @configuration = nil
    end
  end
end
