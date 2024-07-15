# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.sidekiq.uri, size: 15, network_timeout: Settings.redis.sidekiq.network_timeout, pool_timeout: Settings.redis.sidekiq.pool_timeout }
  config.logger.formatter = Sidekiq::Logger::Formatters::JSON.new
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.sidekiq.uri, size: 2, network_timeout: Settings.redis.sidekiq.network_timeout, pool_timeout: Settings.redis.sidekiq.pool_timeout }
end
