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
end