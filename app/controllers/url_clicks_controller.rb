class UrlClicksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_click, only: [:show, :edit, :update]
  before_action :set_user

  # GET /cities
  # GET /cities.json
  def index
    @page_title = 'URL Clicks'
    @pagy, @clicks = pagy(UrlClicks.all, items: 100)
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
   @page_title = @city.name
  end

  # GET /cities/new
  def new
    @click = UrlClicks.new
    @page_title = 'New Url Click'
  end

  # GET /cities/1/edit
  def edit
    @page_title = 'Edit Click'
  end

  # POST /cities
  # POST /cities.json
  def create
    @click = UrlClick.new(click_params)

    respond_to do |format|
      if @click.save
        format.html { redirect_to @click, notice: 'Click was successfully created.' }
        format.json { render :show, status: :created, location: @click }
      else
        @page_title = 'New Click'
        format.html { render :new }
        format.json { render json: @click.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @click.update(click_params)
        format.html { redirect_to @city, notice: 'Click was successfully updated.' }
        format.json { render :show, status: :ok, location: @click }
      else
        @page_title = 'Edit Click'
        format.html { render :edit }
        format.json { render json: @click.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_click
      @click ||= Click.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def click_params
      params.require(:click).permit(:user_id, :shorten_url_id)
    end
end
