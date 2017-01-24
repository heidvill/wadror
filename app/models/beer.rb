class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery #, optional: true <-- tällä saatiin virheilmoitusharjoitus
  has_many :ratings, dependent: :destroy

  # def average_rating
    # sum = 0
    # ratings.all.each do |r|
    # sum = sum + r.score
    # end
    # sum = sum/ratings.count
    # ratings.inject(0) {|sum, alkio| sum + alkio.score}.to_f/ratings.count
    # ratings.average(:score)
    # ratings.map(&:score).sum.to_f/ratings.count
  # end

  def to_s
    "#{name}, #{brewery.name}"
  end

end
