class Order < ApplicationRecord
  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }

  has_many :line_items, dependent: :destroy
  belongs_to :voucher, optional: true

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

  def sub_total_price
    sum = 0
    line_items.each do |line_item|
      sum += line_item.total_price
    end
    sum
  end

  def discount
    discount = 0
    if voucher.unit == "percent"
      calculated_discount = voucher.amount/100 * sub_total_price
      discount = calculated_discount > voucher.max_amount ? voucher.max_amount : calculated_discount
    else
      discount = order.voucher.amount
    end
    discount
  end

  def total_price
    sub_total_price - discount
  end
end
