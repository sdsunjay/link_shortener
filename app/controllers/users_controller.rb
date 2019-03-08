class UsersController < ApplicationController
  include Pagy::Frontend
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]

  # GET /users/:id.:format
  def show
    @page_title = @user.name
    @pagy, @urls = pagy(@user.shorten_urls, items: 100)
  end

  private

  def user_params
    # extend with your own params
    accessible = %i[name email]
    params.require(:user).permit(accessible)
  end
end
