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
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?
    grouped_by_category = ratings.group_by { |r| r.beer.send(category) }
    points = {}
    grouped_by_category.keys.each do |key|
      points[key] = grouped_by_category[key].map(&:score).sum.to_f/grouped_by_category[key].count
    end
    points.sort_by { |_key, value| value }.reverse!.first[0].name
  end

  def self.top(n)
    sorted_by_rating_amount_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count) }
    sorted_by_rating_amount_in_desc_order[0..(n-1)]
  end

end
