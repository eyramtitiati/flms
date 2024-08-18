class Venue < ApplicationRecord
  belongs_to :location
  has_many :bookings

  validates :name, presence: true
  validates :location, presence: true
end
