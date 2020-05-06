# frozen_string_literal: true

$REDIS_CLIENT = Redis.new url: Settings.redis.database.uri
