require 'rails_helper'

describe Order do
  it "has a valid factory" do
    expect(build(:order)).to be_valid
  end

  it "is valid with a name, address, email, and payment_type" do
    expect(build(:order)).to be_valid
  end

  it "is invalid without a name" do
    order = build(:order, name: nil)
    order.valid?
    expect(order.errors[:name]).to include("can't be blank")
  end

  it "is invalid without an address" do
    order = build(:order, address: nil)
    order.valid?
    expect(order.errors[:address]).to include("can't be blank")
  end

  it "is invalid without an email" do
    order = build(:order, email: nil)
    order.valid?
    expect(order.errors[:email]).to include("can't be blank")
  end

  it "is invalid with email not in valid email format" do
    order = build(:order, email: "email")
    order.valid?
    expect(order.errors[:email]).to include("must be in valid email format")
  end

  it "is invalid without a payment_type" do
    order = build(:order, payment_type: nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it "is invalid with wrong payment_type" do
    expect{ build(:order, payment_type: "Grab Pay") }.to raise_error(ArgumentError)
  end

  describe "adding line_items from cart" do
    before :each do
      @cart = create(:cart)
      @line_item = create(:line_item, cart: @cart)
      @order = build(:order)
    end
    
    it "add line_items to order" do
      expect{
        @order.add_line_items(@cart)
        @order.save
      }.to change(@order.line_items, :count).by(1)
    end

    it "removes line_items from cart" do
      expect{
        @order.add_line_items(@cart)
        @order.save
      }.to change(@cart.line_items, :count).by(-1)
    end
  end

  describe "adding discount to order" do
    context "with valid voucher" do
      before :each do
        @voucher = create(:voucher, code: 'VOUCHER1', amount: 15.0, unit: "percent", max_amount: 10000)
        @cart = create(:cart)
        @food = create(:food, price: 100000.0)
        @line_item = create(:line_item, quantity: 1, food: @food, cart: @cart)
        @order = create(:order, voucher: @voucher)
        @order.add_line_items(@cart)
      end

      it "can calculate sub total price" do
        @order.save
        expect(@order.sub_total_price).to eq(100000)
      end

      context "with voucher in percent" do
        it "can calculate discount" do
          voucher = create(:voucher, code: 'VOUCHER2', amount: 5, unit: "percent", max_amount: 10000)
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          order.save
          expect(order.discount).to eq(5000)
        end

        it "changes discount to max_amount if discount is bigger than max_amount" do
          @order.save
          expect(@order.discount).to eq(10000)
        end
      end

      context "with voucher in rupiah" do
        it "can calculate discount" do
          voucher = create(:voucher, amount: 5000, unit: "rupiah", max_amount: 10000)
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          order.save
          expect(order.discount).to eq(5000)
        end
      end

      it "can calculate total price" do
        @order.save
        expect(@order.total_price).to eq(90000)
      end
    end

    context "with invalid voucher" do
      it "is invalid with invalid voucher" do
        voucher = create(:voucher, valid_through: 1.day.ago)
        order = build(:order, voucher: voucher)
        order.valid?
        expect(order.errors[:base]).to include("must use valid voucher")
      end
    end
  end

  describe "search" do
    before :each do
      food1 = create(:food, price: 10000.0)
      line_item1 = create(:line_item, quantity: 1, food: food1)
      @searched_order1 = create(:order, name: "Iqbal", address: "Jatiwaringin", email: "farabi.iqbal@gmail.com", payment_type: "Cash")
      @searched_order1.line_items << line_item1
      @searched_order1.save
      
      food2 = create(:food, price: 20000.0)
      line_item2 = create(:line_item, quantity: 1, food: food2)
      @searched_order2 = create(:order, name: "Farabi", address: "Bekasi", email: "iqbal.farabi@virkea.com", payment_type: "Go Pay")
      @searched_order2.line_items << line_item2
      @searched_order2.save

      food3 = create(:food, price: 30000.0)
      line_item3 = create(:line_item, quantity: 1, food: food3)
      @searched_order3 = create(:order, name: "Iqbal Farabi", address: "Jawa Barat", email: "iqbal@starqle.com", payment_type: "Credit Card", total_price: 30000)
      @searched_order3.line_items << line_item3
      @searched_order3.save
    end

    it "can be searched by name" do
      expect(Order.search(name_like: "iqbal")).to eq([@searched_order1, @searched_order3])
    end

    it "can be searched by address" do
      expect(Order.search(address_like: "bekasi")).to eq([@searched_order2])
    end

    it "can be searched by email" do
      expect(Order.search(email_like: "farabi")).to eq([@searched_order1, @searched_order2])
    end

    it "can be searched by minimum total price" do
      expect(Order.search(minimum_total_price: 15000)).to eq([@searched_order2, @searched_order3])
    end

    it "can be searched by maximum total price" do
      expect(Order.search(maximum_total_price: 25000)).to eq([@searched_order1, @searched_order2])
    end
  end
end