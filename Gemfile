source 'https://rubygems.org'
ruby '2.3.4'

gem 'rails', '>= 5.0.0', '< 5.1'

# Postgres and full-text search
gem 'pg'
gem 'pg_search'

# Sidekiq
gem 'sidekiq'

# Sinatra for the Sidekiq monitoring interface
# For Rails 5 compatibility: https://github.com/sinatra/sinatra/issues/1135
gem 'sinatra', github: 'sinatra/sinatra', require: false
gem 'rack-protection', github: 'sinatra/rack-protection'

# Asset gems
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

# Do not upgrade Bootstrap lightly, lots of incompatibilities
gem 'bootstrap', '4.0.0.alpha3.1'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# For fetching song information
gem 'opengraph', github:'lawadvisor/opengraph', ref: '56820b3'

# Rails helpers
gem 'simple_form'
gem 'kaminari' # pagination
gem 'redcarpet' # markdown

# Inlining CSS and generating text emails
gem 'premailer-rails'

gem 'haml'

# For testing
gem 'nokogiri'
gem 'timecop' # Enable time travel

# CI driven code coverage
gem 'coveralls', require: false

# Deployment
gem 'puma', '~> 3.0'

# For Rake tasks
gem 'ruby-progressbar', '1.8.1'

group :production do
  gem 'rails_12factor'
  gem 'rollbar'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
  gem 'faker'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
