require 'rails_helper'

describe Cart do
  it "has a valid factory" do
    expect(build(:cart)).to be_valid
  end

  it "deletes line_items when deleted" do
    cart = create(:cart)
    food1 = create(:food)
    food2 = create(:food)
    
    line_item1 = create(:line_item, cart: cart, food: food1)
    line_item2 = create(:line_item, cart: cart, food: food2)
    cart.line_items << line_item1
    cart.line_items << line_item2


    expect { cart.destroy }.to change { LineItem.count }.by(-2)
  end

  context "with existing line_item with the same food" do
    before :each do
      @cart = create(:cart)
      @food = create(:food)
      @line_item = create(:line_item, food: @food, cart: @cart)
    end
    
    it "does not save the new line_item in the database" do
      expect { @cart.add_food(@food).save }.not_to change(LineItem, :count)
    end

    it "increments the quantity of line_item with the same food" do
      expect { @cart.add_food(@food).save }.to change {
        @cart.line_items.find_by(food_id: @food.id).quantity
      }.by(1)
    end
  end

  context "without existing line_item with the same food" do
    it "saves the new line_item in the database" do
      cart = create(:cart)
      food = create(:food)
      expect { cart.add_food(food).save }.to change(LineItem, :count).by(1)
    end
  end

  it "can calculate total_price" do
    cart = create(:cart)
    food1 = create(:food, name: "Food 1", price: 10000.0)
    food2 = create(:food, name: "Food 2", price: 15000.0)
    line_item1 = create(:line_item, quantity: 3, food: food1, cart: cart)
    line_item2 = create(:line_item, quantity: 1, food: food2, cart: cart)

    expect(cart.total_price).to eq(45000.0)
  end
end
