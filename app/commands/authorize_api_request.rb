# frozen_string_literal: true

# Authorize user by dencoding link_id
class AuthorizeApiRequest
  include ::ActionController::Cookies
  prepend SimpleCommand

  def initialize(token)
    @token = token
  end

  def call
    link
  end

  private

  def link
    @link ||= ShortenUrl.find(decoded_auth_token[:link_id]) if decoded_auth_token
    @link || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(@token)
  end
end
