module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty? or ratings.nil?
    ratings.average(:score) # .to_d.truncate(2).to_f
  end

end