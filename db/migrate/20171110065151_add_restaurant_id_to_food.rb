class AddRestaurantIdToFood < ActiveRecord::Migration[5.0]
  def change
    add_column :foods, :restaurant_id, :integer
  end
end
