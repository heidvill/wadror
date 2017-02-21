class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  # validates :username, uniqueness: true
  # validates :username, length: { minimum: 3 }
  validates :username, uniqueness: true,
            length: {minimum: 3,
                     maximum: 30}
  validates :password, length: {minimum: 4}

  validate :check_password

  def check_password
    errors.add(:password, "must have atleast one capital letter") if password and password == password.downcase
    errors.add(:password, "must have atleast one number") if password and password.count("0-9") == 0
  end

  def to_s
    username
  end

  def favorite_beer
    return nil if ratings.empty?
    # ratings.sort_by{ |r| r.score }.last.beer
    # ratings.sort_by(&:score).last.beer
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    g = ratings.group_by { |r| r.beer.style }
    pisteet = Hash.new
    g.keys.each do |style|
       pisteet[style] = g[style].map(&:score).sum.to_f/g[style].count

    end
    pisteet.sort_by { |_key, value| value }.reverse!.first[0].name
  end

  def favorite_brewery
    return nil if ratings.empty?
    g = ratings.group_by { |r| r.beer.brewery }
    pisteet = Hash.new
    g.keys.each do |b|
      pisteet[b] = g[b].map(&:score).sum.to_f/g[b].count
    end
    pisteet.sort_by { |_key, value| value }.reverse!.first[0].name
  end

  def self.top(n)
    sorted_by_rating_amount_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count) }
    sorted_by_rating_amount_in_desc_order[0..(n-1)]
  end

end
