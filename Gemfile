source "https://rubygems.org"

ruby "3.1.7"

gem "rails", "~> 7.1.5", ">= 7.1.5.1"
gem "bootsnap", require: false
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem 'kaminari'
gem 'graphql'
gem 'graphql-batch'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rubocop", require: false
  gem "rubocop-graphql", require: false
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "annotate"
  gem 'letter_opener_web', '~> 1.0'
  gem 'graphiql-rails'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
