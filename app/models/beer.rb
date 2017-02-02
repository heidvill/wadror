class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery #, optional: true <-- tällä saatiin virheilmoitusharjoitus vk2
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, length: { minimum: 1}

  # def average_rating
    # sum = 0
    # ratings.all.each do |r|
    # sum = sum + r.score
    # end
    # sum = sum/ratings.count
    # ratings.inject(0) {|sum, alkio| sum + alkio.score}.to_f/ratings.count
    # ratings.average(:score)
    # ratings.map(&:score).sum.to_f/ratings.count
    # ratings.map { |r| r.score }.sum / ratings.count.to_f
    # ratings.map do |r| r.score end .sum / ratings.count.to_f
  # end

  def to_s
    "#{name}, #{brewery.name}"
  end

end
