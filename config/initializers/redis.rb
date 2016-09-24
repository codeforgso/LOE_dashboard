# redis
unless Rails.env.production?
  Rails.application.config.cache_store = :redis_store, "redis://localhost:6379/#{ENV['REDIS_DATABASE']}/cache", { expires_in: 20.minutes }
end