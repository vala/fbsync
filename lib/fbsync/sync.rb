module Fbsync
  class Sync
    class << self

      # Allows to run operations on a Facebook user from a given Fbsync::Token
      # object. The passed block will be passed a FbGraph::User argument to
      # work on.
      # This method ensures the token admin is aware
      #
      # @param  [Fbsync::Token]  token  The token object to deal with
      #
      def run token = nil, &block
        token ||= Fbsync.token_fetch_method.call

        if token.active?
          # Remind if necessary
          #
          # Pre-expiry reminder doesn't work because of this issue :
          # http://developers.facebook.com/bugs/511955848814498
          #
          # if token.expires_soon? && !token.expiration_reminded?
          #   Fbsync::Mailer.token_expires_soon(token)
          # end
          # Execute passed block
          block.call(token.value)
        elsif !token.reminded_since_expiration?
          Fbsync::Mailer.token_expired(token)
        end
      end
    end

  end
end