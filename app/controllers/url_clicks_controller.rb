class UrlClicksController < ApplicationController

  # POST /url_click
  # POST /url_click.json
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def click_params
      params.require(:click).permit(:shorten_url_id)
    end
end
