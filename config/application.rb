# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'active_record/railtie'
# require 'active_storage/engine'
# require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'action_view/component/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myaccount
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.time_zone = 'Eastern Time (US & Canada)'
    config.catalog_url = 'https://catalog.libraries.psu.edu/catalog/'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Use rspec instead
    config.generators { |generator| generator.test_framework :rspec }

    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :library_id
    end

    config.cache_store = :redis_cache_store, { url: 'redis://127.0.0.1:6379/1' }#ENV['REDIS_URL'] }
    config.action_controller.perform_caching = true
    config.session_store :cache_store, key: ENV['APP_SESSION_KEY']

  end
end
