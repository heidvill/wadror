class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, optional: true # <-- tällä saadaan virheilmoitusharjoitus vk2 ja testit vk4
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, length: {minimum: 1}
  validates :style, length: {minimum: 1}

  def to_s
    "#{name}, #{brewery.name}"
  end

end