module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.average(:score) # .to_d.truncate(2).to_f
  end

end