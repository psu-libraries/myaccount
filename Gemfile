# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'config', '~> 2.0'
gem 'http', '~> 4.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.0'
gem 'sqlite3', '~> 1.4'
gem 'turbolinks', '~> 5'
gem 'warden', '~> 1.2'
gem 'webpacker', '~> 4.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman', '~> 0.63.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'niftany'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'warden-rspec-rails'
  gem 'webdrivers', '~> 4.0'
  gem 'webmock', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
