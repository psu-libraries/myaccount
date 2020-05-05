Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.sidekiq.uri, size: 15 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.sidekiq.uri, size: 1 }
end