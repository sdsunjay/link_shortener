# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  include ::ActionController::Cookies
  include Pagy::Backend
  protect_from_forgery with: :exception
  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
