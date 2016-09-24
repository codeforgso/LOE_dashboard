source 'https://rubygems.org'

gem 'rails', '4.2.7.1'
gem 'pg'

# use environmental variables for config and sensitive values
# Make sure to require this first before any gems that need env variables
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# use soda-ruby for access to Socrata data
gem 'soda-ruby',              :require => 'soda'

# use kaminari for pagination
gem 'kaminari'

# use activerecord-import for bulk inserts
gem 'activerecord-import'

# redis
gem 'redis-rails'

# Use Bootstrap framework for UI
gem 'bootstrap-sass', '~> 3.3.7'
gem 'bootstrap-kaminari-views'
gem 'bootstrap-datepicker-rails'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
end

group :production do
  gem 'puma'
end
