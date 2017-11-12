require 'rails_helper'

describe Food do
  it "has a valid factory" do
    expect(build(:food)).to be_valid
  end

  it "is valid with a name and description" do
    expect(build(:food)).to be_valid
  end

  it "is invalid without a name" do
    food = build(:food, name: nil)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a description" do
    food = build(:food, description: nil)
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    food1 = create(:food, name: "Nasi Uduk")
    food2 = build(:food, name: "Nasi Uduk")

    food2.valid?
    expect(food2.errors[:name]).to include("has already been taken")
  end

  it "is valid with numeric price greater or equal to 0.01" do
    expect(build(:food, price: 0.01)).to be_valid
  end

  it "is invalid without numeric price" do
    food = build(:food, price: "abc")
    food.valid?
    expect(food.errors[:price]).to include("is not a number")
  end

  it "is invalid with price less than 0.01" do
    food = build(:food, price: -10)
    food.valid?
    expect(food.errors[:price]).to include("must be greater than or equal to 0.01")
  end

  it "is valid with image_url ending with '.gif', '.jpg', or '.png'" do
    expect(build(:food, image_url: "food.jpg")).to be_valid
  end

  it "is invalid with image_url ending not with '.gif', '.jpg', or '.png'" do
    food = build(:food, image_url: "food.csv")
    food.valid?
    expect(food.errors[:image_url]).to include("must be a URL for GIF, JPG or PNG image.")
  end

  it "is invalid without category" do
    food = build(:food, category: nil)
    food.valid?
    expect(food.errors[:category]).to include("must exist")
  end

  it "is invalid without restaurant" do
    food = build(:food, restaurant: nil)
    food.valid?
    expect(food.errors[:restaurant]).to include("must exist")
  end

  describe "filter name by letter" do
    before :each do
      @food1 = create(:food, name: "Nasi Uduk")
      @food2 = create(:food, name: "Kerak Telor")
      @food3 = create(:food, name: "Nasi Semur Jengkol")
    end

    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Food.by_letter("N")).to eq([@food3, @food1])
      end
    end

    context "with non-matching letters" do
      it "omits results that do not match" do
        expect(Food.by_letter("N")).not_to include(@food2)
      end
    end
  end

  describe "search" do
    it "can be searched by name" do
      food1 = create(:food, name: "Ayam Rica-Rica")
      food2 = create(:food, name: "Steak Ayam BBQ")
      food3 = create(:food, name: "Nasi Goreng Ayam")
      expect(Food.search(name_like: "ayam")).to eq([food1, food2, food3])
    end
  end

  it "can't be destroyed while it has line_item(s)" do
    cart = create(:cart)
    food = create(:food)
    
    line_item = create(:line_item, cart: cart, food: food)
    food.line_items << line_item

    expect { food.destroy }.not_to change(Food, :count)
  end

  it "can be associated with many tags" do
    tag1 = create(:tag)
    tag2 = create(:tag)
    food = create(:food)

    food.tags << tag1
    food.tags << tag2
    expect(food.tags.count).to eq(2)
  end
end