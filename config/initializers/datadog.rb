# frozen_string_literal: true

if Settings.datadog == 'true'
  require 'ddtrace'
  Datadog.configure do |c|
    c.use :rails
    c.use :httprb
    c.use :sidekiq
    c.use :redis
  end
end
