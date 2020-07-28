# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'config', '~> 2.0'
gem 'hiredis'
gem 'http', '~> 4.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 6.0.2'
gem 'redis'
gem 'sidekiq'
gem 'simplecov', '< 0.18', require: false, group: :test
gem 'view_component'
gem 'warden', '~> 1.2'
gem 'webpacker'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'niftany'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'selenium-webdriver'
  gem 'sinatra', require: false # used for faking the symphony api for integration tests
  gem 'warden-rspec-rails'
  gem 'webdrivers', '~> 4.0'
  gem 'webmock'
end
