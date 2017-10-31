class Order < ApplicationRecord
  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }

  has_many :line_items, dependent: :destroy

  validates :name, :address, :email, :payment_type, presence: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'must be in valid email format'
  }
  validates :payment_type, inclusion: payment_types.keys

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
