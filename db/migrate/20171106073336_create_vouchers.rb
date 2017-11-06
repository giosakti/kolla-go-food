class CreateVouchers < ActiveRecord::Migration[5.0]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.date :valid_from
      t.date :valid_through
      t.float :amount
      t.string :unit
      t.float :max_amount

      t.timestamps
    end
  end
end
