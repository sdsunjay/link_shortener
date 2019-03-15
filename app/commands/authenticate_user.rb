# frozen_string_literal: true

# Authorize user by encoding link_id
class AuthenticateUser
  prepend SimpleCommand

  def initialize(admin_url)
    @admin_url = admin_url
  end

  def call
    JsonWebToken.encode(link_id: link.id) if link
  end

  private

  attr_accessor :admin_url

  def link
    link = ShortenUrl.where(admin_url: @admin_url).first
    return link if link

    errors.add :user_authentication, 'invalid admin url'
    nil
  end
end
