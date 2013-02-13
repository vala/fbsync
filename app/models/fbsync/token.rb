module Fbsync
  class Token < ActiveRecord::Base
    attr_accessible :value, :last_expiration_reminder,
      :token_owner_id, :token_owner_type

    belongs_to :token_owner, polymorphic: true

    validate :valid_token

    before_validation do
      self.value = exchange_token(value).to_s if value_changed?
    end

    def expiration_reminded?
      !!last_expiration_reminder
    end

    def reminded_since_expiration?
      last_expiration_reminder > token_data.expires_at
    end

    def expires_soon?
      token_data.expires_at < (Time.now + Fbsync.remind_expiration_before)
    end

    def active?
      token_data.is_valid
    end

    def expires_at
      token_data.expires_at
    end

    # Loads token debug data from cache if existing, or uses
    # #load_token_debug_data to fetch it.
    #
    # An optional options hash can be passed to the method with a :force_reload
    # key to force fetching data from facebook and updating cache
    #
    def token_data options = {}
      if options[:force_reload]
        @_token_data = load_token_debug_data
      else
        @_token_data ||= load_token_debug_data
      end
    end

    private

    # Loads token debug data from facebook debug API
    def load_token_debug_data
      app = FbGraph::Application.new(
          Fbsync.credentials[:id],
          secret: Fbsync.credentials[:secret]
        )
      app.debug_token(value)
    end

    # Gets a long lived token from a given short lived one
    #
    def exchange_token token
      auth = FbGraph::Auth.new(
        Fbsync.credentials[:id],
        Fbsync.credentials[:secret]
      )
      auth.exchange_token!(token)
      auth.access_token
    end

    # Checks if an updated or new facebook token is valid by querying
    # the token debug API
    #
    def valid_token
      unless !value_changed? || token_data(refresh: true).is_valid
        errors.add(
          :value,
          I18n.translate(
            'fbsync.activerecord.errors.token.invalid_token',
            expires_at: I18n.localize(token_data.expires_at)
          )
        )
      end
    end
  end
end
