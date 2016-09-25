# redis
if Rails.env.production?
  url = ENV['REDIS_URL']
  expire = 24.hours
else
  url = "redis://localhost:6379/#{ENV['REDIS_DATABASE']}/cache"
  expire = 20.minutes
end
Rails.application.config.cache_store = :redis_store, url, { expires_in: expire }