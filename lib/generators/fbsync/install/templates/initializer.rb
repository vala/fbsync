Fbsync.config do |config|

  # Your Facebook creadentials
  #
  config.credentials = { id: 'APP_ID', secret: 'APP_SECRET' }

  # An automatic method to fetch your admin's Facebook token from DB
  #
  # Examples :
  #  If you have a single admin and a single token, you could do something
  #  like that :
  #    lambda { User.admins.first.token }
  #
  # config.token_fetch_method = lambda {}

  # The e-mail sender from which token expiration warnings will be sent
  #
  config.email_sender = 'change-email_sender-in-config-initializer-fbsync@example.com'

  # The e-mail recipient to which token expiration warnings will be sent
  #
  config.email_recipient = 'change-email_recipient-in-config-initializer-fbsync@example.com'

  # The time before the token expiration date after which we'll send
  # a warning e-mail to the administrator when Fbsync::Sync.run is called
  #
  # Default is 2 days : an e-mail will be sent 2 days before the token's
  # expiration date
  #
  # config.remind_expiration_before = 2.days
end
