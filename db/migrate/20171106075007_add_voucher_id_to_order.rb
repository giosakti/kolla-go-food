class AddVoucherIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :voucher_id, :integer
  end
end
