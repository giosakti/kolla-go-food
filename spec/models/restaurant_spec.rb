require 'rails_helper'

describe Restaurant do
  it "has a valid factory" do
    expect(build(:restaurant)).to be_valid
  end

  it "is valid with a name" do
    expect(build(:restaurant)).to be_valid
  end

  it "is invalid without a name" do
    restaurant = build(:restaurant, name: nil)
    restaurant.valid?
    expect(restaurant.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    restaurant1 = create(:restaurant, name: "Restaurant 1")
    restaurant2 = build(:restaurant, name: "Restaurant 1")
    restaurant2.valid?
    expect(restaurant2.errors[:name]).to include("has already been taken")
  end

  it "increases foods count whenever a food is added" do
    restaurant = create(:restaurant, name: "Restaurant 1")
    category = create(:category)
    expect {
      restaurant.foods.create(name: "Food 1", description: "Food 1", price: 10000, category_id: category.id)
    }.to change { Restaurant.find_by(name: "Restaurant 1").foods_count }.by(1)
  end

  describe "search" do
    before :each do
      category = create(:category)
      
      @searched_restaurant1 = create(:restaurant, name: "Kopi Oei", address: "Sabang")
      @searched_restaurant1.foods.create(name: "Food 1", description: "Food 1", price: 10000, category_id: category.id)
      
      @searched_restaurant2 = create(:restaurant, name: "Anomali Kopi", address: "Setiabudi")
      @searched_restaurant2.foods.create(name: "Food 2", description: "Food 2", price: 10000, category_id: category.id)
      @searched_restaurant2.foods.create(name: "Food 3", description: "Food 3", price: 10000, category_id: category.id)
    end

    it "can be searched by name" do
      expect(Restaurant.search(name_like: "kopi")).to eq([@searched_restaurant1, @searched_restaurant2])
    end

    it "can be searched by address" do
      expect(Restaurant.search(address_like: "sabang")).to eq([@searched_restaurant1])
    end

    it "can be searched by minimum foods count" do
      expect(Restaurant.search(minimum_foods_count: 2)).to eq([@searched_restaurant2])
    end

    it "can be searched by maximum foods count" do
      expect(Restaurant.search(maximum_foods_count: 1)).to eq([@searched_restaurant1])
    end
  end
end