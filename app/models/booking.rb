class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  validate :booking_date_must_be_available

  private

  def booking_date_must_be_available
    booked_dates = Booking.where(venue: venue).pluck(:booking_date)
    if booked_dates.include?(booking_date)
      errors.add(:booking_date, "is already booked for this venue.")
    end
  end
end
