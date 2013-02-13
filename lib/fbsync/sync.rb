module Fbsync
  class Sync
    class << self

      # Allows to run operations on a Facebook user from a given Fbsync::Token
      # object. The passed block will be passed a FbGraph::User argument to
      # work on.
      # This method ensures the token admin is aware
      #
      #
      def run token = nil, &block
        token ||= Fbsync.token_fetch_method.call

        if token.active?
          # Remind if necessary
          if token.expires_soon? && !token.expiration_reminded?
            Mailer.token_expires_soon(sync)
          end
          # Build Facebook user from token
          user = FbGraph::User.me(token.value)
          # Execute passed block
          block.call(user)
        elsif !token.reminded_since_expiration?
          Mailer.token_expired(sync)
        end
      end
    end

  end
end