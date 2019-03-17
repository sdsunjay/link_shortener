# frozen_string_literal: true

# Authorize user by dencoding link_id
class AuthorizeApiRequest
  include ::ActionController::Cookies
  prepend SimpleCommand

  def initialize(token, link_id)
    @token = token
    @link_id = link_id
  end

  def call
    link
  end

  private

  def link
    decoded_auth_token
    if (@decoded_auth_token && @decoded_auth_token[:link_id].to_i == @link_id.to_i)
      @link = ShortenUrl.find(@decoded_auth_token[:link_id])
    end
    @link || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(@token)
  end
end
