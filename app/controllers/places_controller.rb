class PlacesController < ApplicationController
  before_action :set_place, only: [:show]
  require 'beermapping_api'
  require 'weather_api'

  def index
  end

  def show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.weather_in(params[:city])
    session[:last_city] = params[:city]
=begin
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
=end
      render :index
   # end
  end

  private
  def set_place
    # @places = BeermappingApi.places_in(session[:last_city])
    # @place = @places.select { |p| p.id == params[:id].to_s }.first
    @place = BeermappingApi.find(params[:id], session[:last_city])
  end
end