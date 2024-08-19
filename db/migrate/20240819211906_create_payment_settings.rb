class CreatePaymentSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
