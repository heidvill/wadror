class Style < ApplicationRecord
  include RatingAverage
  include TopN

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

end
