class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, length: {minimum: 1}
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true}

  validate :check_year

  def check_year
    errors.add(:year, "too big value") if year > Time.now.year
  end

end