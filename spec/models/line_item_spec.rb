require 'rails_helper'

describe LineItem do
  it "has a valid factory" do
    expect(build(:line_item)).to be_valid
  end

  it "can calculate total_price" do
    cart = create(:cart)
    food = create(:food, price: 10000.0)
    line_item = create(:line_item, quantity: 3, food: food, cart: cart)

    expect(line_item.total_price).to eq(30000.0)
  end
end