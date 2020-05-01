Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.sidekiq.uri }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.sidekiq.uri }
end