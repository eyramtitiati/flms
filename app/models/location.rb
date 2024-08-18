class Location < ApplicationRecord
    has_many :venues
  
    validates :name, presence: true
    validates :contact_person, presence: true
  end
  