module Fbsync
  class Mailer < ActionMailer::Base
    default to: Fbsync.email_recipient, from: Fbsync.email_sender

    def token_expired
      mail subject: subject(:token_expired)
    end

    def token_expires_soon
      mail subject: subject(:token_expires_soon)
    end

    private

    def subject key
      "[#{ Fbsync.email_application_prefix }] #{ I18n.t("fbsync.mailer.#{ key }.subject") }"
    end
  end
end