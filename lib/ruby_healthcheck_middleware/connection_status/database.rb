# frozen_string_literal: true

module RubyHealthcheckMiddlewar
  module ConnectionStatus
    # Class Database provides checking of Database connection health status
    class Database
      class << self
        def call(params)
          !!client(params)
        rescue Sequel::DatabaseConnectionError
          false
        end

        def client(params)
          Sequel.connect(
            {
              adapter: params[:adapter],
              database: params[:database_name],
              host: params[:host],
              port: params[:port]
            }.compact
          )
        end
      end
    end
  end
end
