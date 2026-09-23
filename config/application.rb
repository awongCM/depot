require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Depot
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoloader = :zeitwerk

    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en
    config.i18n.enforce_available_locales = true
  end
end
