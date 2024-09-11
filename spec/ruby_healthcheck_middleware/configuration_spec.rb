# frozen_string_literal: true

RSpec.describe RubyHealthcheckMiddleware::Configuration do
  describe '.new' do
    let(:database) { { adapter: 'postgres', database_name: 'postgres' } }
    let(:redis) { { redis_url: 'redis://localhost/' } }
    let(:rabbitmq) { { url: 'amqp://guest:guest@0.0.0.0:5672' } }
    let(:custom_services) { { servis_name: 'name' } }
    let(:services_startup) { %i[redis] }
    let(:services_liveness) { %i[database redis] }
    let(:services_readiness) { %i[database rabbitmq] }
    let(:root_healthcheck_route) { '/test' }
    let(:endpoint_startup) { '/health_test' }
    let(:endpoint_liveness) { '/liveness_test' }
    let(:endpoint_readiness) { '/readiness_test' }

    context 'when valid configuration' do
      subject(:configuration) do
        create_configuration(
          database: database,
          redis: redis,
          rabbitmq: rabbitmq,
          custom_services: custom_services,
          services_startup: services_startup,
          services_liveness: services_liveness,
          services_readiness: services_readiness,
          root_healthcheck_route: root_healthcheck_route,
          endpoint_startup: endpoint_startup,
          endpoint_liveness: endpoint_liveness,
          endpoint_readiness: endpoint_readiness
        )
      end

      it 'creates configuration instance' do
        expect(configuration.database).to eq(database)
        expect(configuration.redis).to eq(redis)
        expect(configuration.rabbitmq).to eq(rabbitmq)
        expect(configuration.custom_services).to eq(custom_services)
        expect(configuration.services_startup).to eq(services_startup)
        expect(configuration.services_liveness).to eq(services_liveness)
        expect(configuration.services_readiness).to eq(services_readiness)
        expect(configuration.root_healthcheck_route).to eq(root_healthcheck_route)
        expect(configuration.endpoint_startup).to eq(endpoint_startup)
        expect(configuration.endpoint_liveness).to eq(endpoint_liveness)
        expect(configuration.endpoint_readiness).to eq(endpoint_readiness)
      end
    end

    context 'when invalid configuration' do
      invalid_argument = 1
      let(:valid_argument_hash) { random_hash }
      let(:valid_argument_array) { random_array }
      let(:valid_argument_url) { random_url }

      context 'when argument database= invalid' do
        subject(:configuration) { create_configuration(database: invalid_argument) }

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :database
      end

      context 'when argument redis= invalid' do
        subject(:configuration) do
          create_configuration(database: valid_argument_hash, redis: invalid_argument)
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :redis
      end

      context 'when argument rabbitmq= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :rabbitmq
      end

      context 'when argument custom_services= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :custom_services
      end

      context 'when argument services_startup= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :services_startup
      end

      context 'when argument services_liveness= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :services_liveness
      end

      context 'when argument services_readiness= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: valid_argument_array,
            services_readiness: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :services_readiness
      end

      context 'when argument root_healthcheck_route= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: valid_argument_array,
            services_readiness: valid_argument_array,
            root_healthcheck_route: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :root_healthcheck_route
      end

      context 'when argument endpoint_startup= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: valid_argument_array,
            services_readiness: valid_argument_array,
            root_healthcheck_route: valid_argument_url,
            endpoint_startup: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :endpoint_startup
      end

      context 'when argument endpoint_liveness= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: valid_argument_array,
            services_readiness: valid_argument_array,
            root_healthcheck_route: valid_argument_url,
            endpoint_startup: valid_argument_url,
            endpoint_liveness: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :endpoint_liveness
      end

      context 'when argument endpoint_readiness= invalid' do
        subject(:configuration) do
          create_configuration(
            database: valid_argument_hash,
            redis: valid_argument_hash,
            rabbitmq: valid_argument_hash,
            custom_services: valid_argument_hash,
            services_startup: valid_argument_array,
            services_liveness: valid_argument_array,
            services_readiness: valid_argument_array,
            root_healthcheck_route: valid_argument_url,
            endpoint_startup: valid_argument_url,
            endpoint_liveness: valid_argument_url,
            endpoint_readiness: invalid_argument
          )
        end

        it_behaves_like 'raise_argument_error_with_message', invalid_argument, :endpoint_readiness
      end
    end

    context 'when configuration without block' do
      subject(:configuration) { create_configuration }

      it 'returns configuration instance' do
        expect(configuration.database).to be_empty
        expect(configuration.redis).to be_empty
        expect(configuration.rabbitmq).to be_empty
        expect(configuration.custom_services).to be_empty
        expect(configuration.services_startup).to eq(RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES)
        expect(configuration.services_liveness).to eq(RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES)
        expect(configuration.services_readiness).to eq(RubyHealthcheckMiddleware::Configuration::DEFAULT_SERVICES)
        expect(configuration.root_healthcheck_route).to eq(RubyHealthcheckMiddleware::Configuration::ROOT_HEALTHCHECK_ROUTE)
        expect(configuration.endpoint_startup).to eq(RubyHealthcheckMiddleware::Configuration::ENDPOINT_STARTUP)
        expect(configuration.endpoint_liveness).to eq(RubyHealthcheckMiddleware::Configuration::ENDPOINT_LIVENESS)
        expect(configuration.endpoint_readiness).to eq(RubyHealthcheckMiddleware::Configuration::ENDPOINT_READINESS)
      end
    end
  end
end
