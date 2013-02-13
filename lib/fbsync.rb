require "fbsync/engine"
require 'fb_graph'

module Fbsync
  mattr_accessor :credentials
  @@credentials = { id: 'APP_ID', secret: 'APP_SECRET' }

  mattr_accessor :token_fetch_method
  @@token_fetch_method = lambda {
    raise "Please pass a token as argument to the Fbsync::Sync#run method or " +
      "override config.token_fetch_method lambda in config/fbsync.rb in " +
      "order to let Fbsync handle token recovery"
  }

  mattr_accessor :remind_expiration_before
  @@remind_expiration_before = 2.days

  mattr_accessor :email_sender
  @@email_sender = ''

  mattr_accessor :email_recipient
  @@email_recipient = ''

  # Allow config block for initializer
  def self.config
    block_given? ? yield(self) : self
  end
end

require "fbsync/sync"