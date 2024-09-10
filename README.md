# `ruby-healthcheck-middleware` - Services healthcheck Rack middleware

Plugin for implementing healthcheck service into Ruby applications

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Configuring](#configuring)
  - [Reseting global configuration](#reseting-global-configuration)
  - [Integration with Rack](#integration-with-rack)
- [Local Testing](local-testing)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Features

- Ability to integrate this approach as Rack middleware out of the box
- Ability to configure services params to set up proper connection
- Ability make request with proper url and retrieve status of app services

## Requirements

Ruby MRI 2.7.0+

## Instalation

Before this RubyHealthchecMiddleware gem must be deployed to your local gems env

Add this line to your application's Gemfile:

```ruby
source 'https://rubygems.your-company.tech' do
  gem 'ruby-healthcheck-middleware'
end
```
And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install ruby-healthcheck-middleware
```

## Usage

## Configuring

To have an access for `RubyHealthcheckMiddleware.configuration` and gem configuration features, you must configure it first as in the example below:

```ruby
require 'ruby_healthcheck_middleware'

# By default Healthcheck gem check three services: Database, Redis, RabbitMQ.
RubyHealthcheckMiddleware.configure do |config|
  # Set up services you have in application
  config.services_startup = %i[database redis rabbitmq service_name]
  # If application has data base you need to set database params:
  # config.database = { adapter: 'postgres', database_name: 'postgres', password: '12345', etc }
  # Parameters: :adapter, :database_name are required, rest of parameters such as: :port, :host, :password are optional
  # You have two options for :adapter - 'postgres' or 'tiny_tds'
  config.database = { adapter: 'postgres', database_name: 'postgres', password: '12345' }

  # If application has Redis database you need to set redis params:
  # config.redis = { url: 'redis://localhost/', user: 'user', password: '12345' }
  # all params in hash are optional
  config.redis = { url: 'redis://localhost/', user: 'user', password: '12345' }

  # If application has RabbitMQ  you need to set params:
  # config.rabbitmq = { 'amqp://guest:guest@0.0.0.0:5672' } or set param from env ENV.fetch('RABBITMQ_URL)
  # all params in hash are optional
  config.rabbitmq = { 'amqp://guest:guest@0.0.0.0:5672' }

  # If application has custom services you need to set up configuration:
  # config.custom_services = { service_name: some callable object } where:
  # key   - 'service_name' must be setted up in config.services_startup
  # value - 'some callable object' must be as boolean response
  config.custom_services = { service_name: -> { true } }

  # Optional parameter. By default setted as [redis rabbitmq database]
  # Use this configuration for separate liveness report, good for k8s
  config.services_liveness = %i[redis rabbitmq custom]

  # Optional parameter. By default setted as [redis rabbitmq database]
  # Use this configuration for separate readiness report, good for k8s
  config.services_readiness = %i[:redis]

  # Optional parameter. By default setted as '/sre'
  config.root_healthcheck_route = '/example'

  # Optional parameter. By default setted as '/health'
  config.endpoint_startup = '/healthcheck'

  # Optional parameter. By default setted as '/liveness'
  config.endpoint_liveness = '/report1'

  # Optional parameter. By default setted as '/readiness'
  config.endpoint_readiness = '/report2'
end
```

#### Notice
- If you have setted up any of default services(:redis, :data_base, :rabbitmq) in ```config.services_startup``` and had not setted up config for this service, the service will not be checked, response status will be success 200
- If you setted up any of custom service in ```config.services_startup``` and had not setted up config for this service, the service will return 'null', response status will be faulture 503

### Reseting global configuration

You can reset `RubyHealthcheckMiddleware` configuration:

```ruby
RubyHealthcheckMiddleware.reset_configuration!
# => nil
RubyHealthcheckMiddleware.configuration
# => nil
```

### Integration with Rack

This exception wrapper could be integrated as Rack middleware:

```ruby
# Example of integration into typical Rack application

class Application < Roda
  opts[:root] = ENV['ROOT']
  use Logs::Middleware::Rack
  use Airbrake::Rack::Middleware
  use RubyHealthcheckMiddleware::Middleware::Rack
  plugin :all_verbs
  plugin :symbol_status
  plugin :json, content_type: 'application/vnd.api+json'
  plugin :json_parser
  plugin :request_headers
  plugin :hash_routes
  plugin :session
end
```

## Local Testing

After configurations were setted up you cat use gem with real request via terminal or Postman
In terminal up service with 9292 port
```
bundle exec rackup
```
Then in postman make request
```
GET http://localhost:9292/example/healthcheck
```
Or in terminal 
```
curl localhost:9292/example/healthcheck
```
#### Example of response

status 200
```
{
    "data": {
        "id": "1160bb6f-2a81-4b07-8783-81037cc27975",
        "type": "application-healthcheck",
        "attributes": {
            "database": true,
            "redis": true
        }
    }
}
```

status 503

```
{
    "data": {
        "id": "31322423-442e-469f-a526-fb8aab5120ff",
        "type": "application-healthcheck",
        "attributes": {
            "database": true,
            "redis": true,
            "some_service_1": null,
            "some_service_2": false
        }
    }
}
```

## Versioning

`ruby_healthcheck_middleware` uses [Semantic Versioning 2.0.0](https://semver.org)

## Changelog
