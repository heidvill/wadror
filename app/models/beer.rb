class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, optional: true # <-- tällä saadaan virheilmoitusharjoitus vk2 ja testit vk4
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user
  belongs_to :style, optional: true

  validates :name, length: {minimum: 1}

  def to_s
    "#{name}, #{brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating) }
    sorted_by_rating_in_desc_order[0..(n-1)]
  end

end