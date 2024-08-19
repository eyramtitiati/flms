class Venue < ApplicationRecord
  belongs_to :location
  has_many :bookings

  validates :name, presence: true
  validates :location, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
