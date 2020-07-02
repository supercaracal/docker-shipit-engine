require_relative 'boot'

require "rails"

# require "action_cable/engine"
# require "action_mailbox/engine"
# require "action_mailer/railtie"
# require "action_text/engine"
# require "active_storage/engine"
# require "rails/test_unit/railtie"

require "action_controller/railtie"
require "action_view/railtie"
require "active_job/railtie"
require "active_model/railtie"
require "active_record/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Shipit
  class Application < Rails::Application
    config.load_defaults 6.0
    config.cache_classes = true
    config.eager_load = true
    config.consider_all_requests_local = false
    config.action_controller.perform_caching = true
    config.public_file_server.enabled = true
    config.assets.compile = false
    config.log_level = :debug
    config.log_tags = [ :request_id ]
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] || 'redis://localhost', expires_in: 90.minutes }
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "shipit"
    Pubsubstub.use_persistent_connections = false
    config.i18n.fallbacks = true
    config.active_support.deprecation = :notify
    config.log_formatter = ::Logger::Formatter.new
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    config.active_record.dump_schema_after_migration = false
  end
end
