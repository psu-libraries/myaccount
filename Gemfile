# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'config', '~> 2.0'
gem 'hiredis'
gem 'http', '~> 4.0'
gem 'lograge'
gem 'logstash-event'
gem 'matrix'
gem 'net-imap'
gem 'net-pop'
gem 'net-smtp'
gem 'okcomputer', '~> 1.18'
gem 'puma', '~> 5.6'
gem 'rails', '~> 6.1.0'
gem 'redis', '~> 4.2.5'
gem 'rexml'
gem 'sidekiq', '~> 6.4.0'
gem 'simplecov', '< 0.18', require: false, group: :test
gem 'simple_json_log_formatter'
gem 'view_component'
gem 'warden', '~> 1.2'
gem 'webpacker'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :development, :test do
  gem 'axe-matchers'
  gem 'byebug'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'niftany'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 6.0.1'
  gem 'selenium-webdriver'
  gem 'sinatra', require: false # used for faking the symphony api for integration tests
  gem 'warden-rspec-rails'
  gem 'webmock'
end

group :production do
  gem 'ddtrace', '~> 0.45'
end
