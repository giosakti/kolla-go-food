class AddTotalPriceToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :discount, :decimal
    add_column :orders, :sub_total_price, :decimal
    add_column :orders, :total_price, :decimal
  end
end
