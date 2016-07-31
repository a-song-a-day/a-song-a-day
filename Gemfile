source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '>= 5.0.0', '< 5.1'
gem 'pg'
gem 'pg_search'

gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'bcrypt', '~> 3.1.7'

gem 'simple_form'
gem 'kaminari'

gem 'premailer-rails'
gem 'nokogiri'

gem 'rollbar'

gem 'opengraph', github:'lawadvisor/opengraph', ref: '56820b3'

gem 'coveralls', require: false

# Do not upgrade Bootstrap lightly, lots of incompatibilities
gem 'bootstrap', '4.0.0.alpha3'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

group :production do
  gem 'rails_12factor'
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
