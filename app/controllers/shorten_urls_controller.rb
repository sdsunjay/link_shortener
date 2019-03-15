# frozen_string_literal: true

# Shorten Urls Controller
class ShortenUrlsController < ApplicationController
  include ::ActionController::Cookies
  before_action :set_url, only: %i[show edit update]
  before_action :authenticate_request, only: %i[show edit update]
  before_action :authenticate, only: [:admin_send_to_url]

  # we may want this in the future
  # GET /urls
  # GET /urls.json
  # def index
  #  @page_title = 'Urls'
  #  @pagy, @urls = pagy(ShortenUrl.all, items: 100)
  #
  #  respond_to do |format|
  #   format.html # index.html.erb
  #   format.json { render json: @url }
  #  end
  # end

  # GET /urls/1
  # GET /urls/1.json
  def show
    @page_title = 'URL'
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/new
  # GET /urls/new.json
  def new
    @page_title = 'New URL'
    @url = ShortenUrl.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/1/edit
  def edit; end

  # POST /urls
  # POST /urls.json
  # POST /urls.js
  def create
    @url = ShortenUrl.new(shorten_url_params)
    if @url.save
      respond_to do |format|
        format.html { redirect_to @url, notice: 'Short URL was successfully created.' }
        format.json { render json: @url, status: :created, location: @url }
        format.js { flash[:notice] = 'Short URL was successfully created' }
      end
    else
      @page_title = 'New URL'
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
        format.js { flash[:alert] = @url.errors.full_messages.to_sentence }
      end
    end
  end

  # PUT /urls/1
  # PUT /urls/1.json
  # PUT /urls/1.js
  def update
    respond_to do |format|
      if @url.update_attributes(shorten_url_params)
        format.html { redirect_to @url, notice: 'Short URL was successfully updated.' }
        format.json { head :no_content }
        format.js { flash[:notice] = 'Short URL was successfully updated' }
      else
        @page_title = 'Edit URL'
        format.html { render action: 'edit' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
        format.js { flash[:alert] = @url.errors.full_messages.to_sentence }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  # we may want this in the future
  def destroy
    if @url.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
      end
    else
      @page_title = 'Edit URL'
      format.html { render action: 'edit' }
      format.json { render json: @url.errors, status: :unprocessable_entity }
      format.js { flash[:alert] = @url.errors.full_messages.to_sentence }
    end
  end

  def send_to_url
    if ShortenUrl.where(short_url: params[:short_url]).exists?
      @link = ShortenUrl.where(short_url: params[:short_url]).first
      if @link.active?
        # Create new click
        UrlClick.create!(shorten_url_id: @link.id)
        redirect_to @link.url
      else
        redirect_to '/404', flash: { alert: 'URL has expired' }
      end
    else
      redirect_to '/404', flash: { alert: 'URL not found' }
    end
  end

  def admin_send_to_url
    @link = ShortenUrl.where(admin_url: params[:admin_url]).first
    if @link
      redirect_to @link
    else
      redirect_to '/404', flash: { alert: 'URL not found' }
    end
  end

  def authenticate
    command = AuthenticateUser.call(params[:admin_url])
    # puts command.inspect
    if command.success?
      # render json: { auth_token: command.result }
      cookies.encrypted[:jwt] = { value: command.result, httponly: true, expires: Time.now + 1.day }
    else
      # render json: { error: command.errors }, status: :unauthorized
      redirect_to '/401', flash: { alert: command.errors }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_url
    @url ||= ShortenUrl.find(params[:id])
  end

  def authenticate_request
    jwt = cookies.encrypted[:jwt]
    @link = AuthorizeApiRequest.call(jwt).result
    redirect_to '/401', flash: { alert: 'Not Authorized' } unless @link
    # render json: { error: 'Not Authorized' }, status: 401 unless @link
  end

  # Never trust parameters from the scary internet
  # only allow the white list through.
  def shorten_url_params
    # extend with your own params
    accessible = %i[original_url status]
    params.require(:shorten_url).permit(accessible)
  end
end
