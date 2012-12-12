require 'openid/store/filesystem'

omniauth_options = { :name => "google" }
omniauth_options[:domain] = if Rails.application.config.respond_to?(:google_auth_domain)
  Rails.application.config.google_auth_domain
else
  'gmail.com'
end

Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('/tmp'), omniauth_options
