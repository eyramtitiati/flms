# app/models/payment_setting.rb
class PaymentSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
end
