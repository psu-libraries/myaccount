# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'actionview-component'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'config', '~> 2.0'
gem 'http', '~> 4.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 6.0.0'
gem 'simplecov', require: false, group: :test
gem 'turbolinks', '~> 5'
gem 'warden', '~> 1.2'
gem 'webpacker', '~> 4.0'

group :production do
  gem 'hiredis'
  gem 'redis'
end

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
  gem 'warden-rspec-rails'
  gem 'webdrivers', '~> 4.0'
  gem 'webmock'
end
