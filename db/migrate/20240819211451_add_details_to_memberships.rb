class AddDetailsToMemberships < ActiveRecord::Migration[7.2]
  def change
    add_column :memberships, :male_birth_date, :date
    add_column :memberships, :female_birth_date, :date
    add_column :memberships, :male_place_of_birth, :string
    add_column :memberships, :female_place_of_birth, :string
    add_column :memberships, :male_residential_address, :string
    add_column :memberships, :female_residential_address, :string
    add_column :memberships, :male_born_again, :string
    add_column :memberships, :female_born_again, :string
    add_column :memberships, :male_born_again_date, :string
    add_column :memberships, :female_born_again_date, :string
    add_column :memberships, :male_born_again_reason, :text
    add_column :memberships, :female_born_again_reason, :text
    add_column :memberships, :male_passport_picture, :string
    add_column :memberships, :female_passport_picture, :string
  end
end
