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
    render :index
  end

  private
  def set_place
    @place = BeermappingApi.find(params[:id], session[:last_city])
  end
end