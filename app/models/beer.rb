class Beer < ApplicationRecord
  include RatingAverage
  include TopN

  belongs_to :brewery, optional: true # <-- tällä saadaan virheilmoitusharjoitus vk2 ja testit vk4
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user
  belongs_to :style, optional: true

  validates :name, length: {minimum: 1}

  def to_s
    name
  end

end