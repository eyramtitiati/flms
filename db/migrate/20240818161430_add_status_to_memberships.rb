class AddStatusToMemberships < ActiveRecord::Migration[7.2]
  def change
    add_column :memberships, :status, :string, default: 'Pending'
  end
end
