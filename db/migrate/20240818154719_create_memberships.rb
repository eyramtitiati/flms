class CreateMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :partner_first_name
      t.string :partner_last_name
      t.string :partner_phone
      t.string :partner_email
      t.string :pastor_name
      t.string :partner_pastor_name
      t.string :ministry
      t.string :partner_ministry
      t.string :lab_results

      t.timestamps
    end
  end
end
