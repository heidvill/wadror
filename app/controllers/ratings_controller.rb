class RatingsController < ApplicationController
  before_action :skip_if_cached, only:[:index]

  def skip_if_cached
    return render :index if fragment_exist? ("rating_statistics")
  end

  def index
    # Etusivun avaamisen tehostamiseksi cache tyhjennetään 10 min välein
    @ratings = Rating.all
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @top_raters = User.top 3
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path(current_user)
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end