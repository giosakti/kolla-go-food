class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.decimal :price

      t.timestamps
    end
  end
end
