# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.1'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'bugsnag', '~> 6.26'
gem 'config', '~> 2.0'
gem 'hiredis'
gem 'http'
gem 'lograge'
gem 'logstash-event'
gem 'matrix'
gem 'mutex_m'
gem 'net-imap'
gem 'net-pop'
gem 'net-smtp'
gem 'okcomputer', '~> 1.18'
gem 'puma', '~> 6'
gem 'rails', '~> 7.2'
gem 'redis', '~> 4.2.5'
gem 'rexml'
gem 'shakapacker', '~> 9'
gem 'sidekiq', '~> 7.1.5'
gem 'simplecov', '~> 0.22', require: false, group: :test
gem 'simple_json_log_formatter'
gem 'view_component'
gem 'warden'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :development, :test do
  gem 'axe-matchers'
  gem 'byebug'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'niftany', '~> 0.12.1'
  gem 'observer'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 6.0.1'
  gem 'selenium-webdriver'
  gem 'sinatra' # used for faking the symphony api for integration tests
  gem 'warden-rspec-rails'
  gem 'webmock'
end
