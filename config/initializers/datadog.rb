# frozen_string_literal: true

if Settings&.datadog&.on_server
  require 'ddtrace'
  Datadog.configure do |c|
    c.service = 'myaccount'
    c.env = Settings.datadog.environment
    c.version = MyaccountVersion::resolve_version
    c.use :rails
    c.use :httprb, service_name: 'myaccount-httprb'
    c.use :sidekiq, service_name: 'myaccount-sidekiq'
    c.use :redis, service_name: 'myaccount-redis'
  end
end
