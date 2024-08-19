class AddPriceToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :price, :decimal, precision: 10, scale: 2
  end
end
