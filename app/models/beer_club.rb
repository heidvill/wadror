class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :name, length: { minimum: 1, maximum: 30 }
  validates :founded, numericality: { greater_than_or_equal_to: 1042,
                                      only_integer: true }
  validates :name, length: { minimum: 1, maximum: 30}
  validate :check_year

  def check_year
    errors.add(:year, "too big value") if year > Time.now.year
  end

  def to_s
    "#{name}"
  end

end
