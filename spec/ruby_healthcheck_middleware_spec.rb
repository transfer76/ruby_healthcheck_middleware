# frozen_string_literal: true

RSpec.describe RubyHealthcheckMiddleware do
  subject(:configuration) { described_class.configure(&config_block) }

  let(:database) { { adapter: 'postgres', database_name: 'postgres' } }
  let(:redis) { { url: 'redis://localhost/' } }
  let(:rabbitmq) { { url: 'amqp://guest:guest@0.0.0.0:5672' } }
  let(:custom_services) { { servis_name: 'name' } }
  let(:services_startup) { %i[redis] }
  let(:services_liveness) { %i[database redis] }
  let(:services_readiness) { %i[database] }
  let(:root_healthcheck_route) { '/test' }
  let(:endpoint_startup) { '/health_test' }
  let(:endpoint_liveness) { '/liveness_test' }
  let(:endpoint_readiness) { '/readiness_test' }
  let(:config_block) do
    configuration_block(
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

  describe 'defined constants' do
    it 'has a version number' do
      expect(RubyHealthcheckMiddleware::VERSION).not_to be_nil
    end

    it { expect(described_class).to be_const_defined(:VERSION) }
  end

  describe '.configure' do
    context 'without block' do
      let(:config_block) { nil }

      it { expect { configuration }.not_to change(described_class, :configuration) }
    end

    context 'with block' do
      context 'when configuration is complete' do
        it 'sets attributes into configuration instance' do
          expect(configuration).to be_an_instance_of(RubyHealthcheckMiddleware::Configuration)
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
    end
  end

  describe '.reset_configuration!' do
    before do
      described_class.configure(&config_block)
    end

    it do
      expect { described_class.reset_configuration! }
        .to change(described_class, :configuration)
        .from(be_instance_of(RubyHealthcheckMiddleware::Configuration)).to(nil)
    end
  end

  describe '.configuration' do
    subject(:configuration) { described_class.configuration }

    before do
      described_class.configure(&config_block)
    end

    it 'returns configuration instance' do
      expect(configuration).to be_instance_of(RubyHealthcheckMiddleware::Configuration)
      expect(configuration).to be_frozen
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
end
