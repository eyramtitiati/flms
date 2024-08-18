# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy       

  # Define roles
  ROLES = %w[admin user].freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  # Set default role after initialization
  after_initialize :set_default_role, if: :new_record?

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  private

  def set_default_role
    self.role ||= 'user'
  end
end
