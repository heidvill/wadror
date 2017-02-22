class Brewery < ApplicationRecord
  include RatingAverage
  include TopN

  validates :name, length: {minimum: 1}
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true}
  validate :check_year

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def check_year
    errors.add(:year, "too big value") if year.nil? or year > Time.now.year
  end

end