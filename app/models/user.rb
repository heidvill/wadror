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
            length: { minimum: 3,
                      maximum: 30}
  validates :password, length: { minimum: 4 }

  validate :check_password

  def check_password
    errors.add(:password, "must have atleast one capital letter") if password and password == password.downcase
    errors.add(:password, "must have atleast one number") if password and password.count("0-9") == 0
  end

  def to_s
    username
  end
end
