class Membership < ApplicationRecord
  belongs_to :user

  # Validations
  validates :first_name, :last_name, :phone, :email, :partner_first_name, :partner_last_name,
            :partner_phone, :partner_email, :pastor_name, :partner_pastor_name, :ministry,
            :partner_ministry, presence: true

  # Assuming you're using Active Storage for file uploads
  has_one_attached :lab_results

  scope :pending, -> { where(status: 'Pending') }
  scope :confirmed, -> { where(status: 'Confirmed') }
end
