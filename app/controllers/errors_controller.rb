# frozen_string_literal: true

# Errors Controller
class ErrorsController < ApplicationController
  def error404
    render status: :not_found
  end

  def error401
    render status: :unauthorized
  end
end
