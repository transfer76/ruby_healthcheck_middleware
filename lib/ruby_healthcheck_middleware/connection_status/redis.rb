# frozen_string_literal: true

module RubyHealthcheckMiddlewar
  module ConnectionStatus
    # Class Redis provides checking of Redis database health status
    class Redis
      class << self
        def call(params)
          client(params).ping.eql?('PONG')
        rescue Redis::BaseConnectionError
          false
        end

        def client(params)
          @client ||= ::Redis.new(url: params[:url],
                                  host: params[:host],
                                  password: params[:password])
        end
      end
    end
  end
end
