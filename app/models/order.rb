class Order < ApplicationRecord
  before_save :calculate_sub_total_price
  before_save :calculate_discount
  before_save :calculate_total_price

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
  validates_with VoucherValidator

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  private
    def calculate_sub_total_price
      sum = 0
      line_items.each do |line_item|
        sum += line_item.total_price
      end
      self.sub_total_price = sum
    end

    def calculate_discount
      amount = 0
      unless voucher.nil?
        if voucher.unit == "percent"
          calculated_discount = voucher.amount/100 * sub_total_price
          amount = calculated_discount > voucher.max_amount ? voucher.max_amount : calculated_discount
        else
          amount = voucher.amount
        end
      end
      self.discount = amount
    end

    def calculate_total_price
      self.total_price = sub_total_price - discount
    end
end
