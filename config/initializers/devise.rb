Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = 'change-me-at-config-initializers-devise@example.com'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 10

  # ==> Configuration for :confirmable
  config.reconfirmable = true

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  config.password_length = 8..72

  # ==> Configuration for :timeoutable

  # ==> Configuration for :lockable

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Configuration for :encryptable

  # ==> Scopes configuration

  # ==> Navigation configuration
  config.sign_out_via = :delete

  # ==> OmniAuth

  # ==> Warden configuration

  # ==> Mountable engine configurations
end
