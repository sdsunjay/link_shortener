require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LinkShortener
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # custom 404
    require Rails.root.join("lib/custom_public_exceptions")
    # JSON web token
    require Rails.root.join("lib/json_web_token")
    config.exceptions_app = CustomPublicExceptions.new(Rails.public_path)
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:3000'
        # origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
