# frozen_string_literal: true

puts Rails.application.config.myaccount_verison
if Settings.datadog
  require 'ddtrace'
  Datadog.configure do |c|
    c.service = 'myaccount'
    c.env = 'production'
    c.version = Rails.application.config.myaccount_verison
    c.use :rails
    c.use :httprb, service_name: 'myaccount-httprb'
    c.use :sidekiq, service_name: 'myaccount-sidekiq'
    c.use :redis, service_name: 'myaccount-redis'
  end
end
