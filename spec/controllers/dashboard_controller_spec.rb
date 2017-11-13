require 'rails_helper'
require 'date'

describe DashboardController do
  describe 'GET #index' do
    it "displays number of order every date" do
      create(:order)
      get :index
      expect(Order.grouped_by_date).to eq({Date.today.strftime("%Y-%m-%d") => 1})
    end

    it "displays total price of order every date" do
      food = create(:food, price: 10000.0)
      line_item = create(:line_item, quantity: 1, food: food)
      order = create(:order)
      order.line_items << line_item
      order.save

      get :index
      expect(Order.grouped_by_total_price_per_date).to eq({Date.today.strftime("%Y-%m-%d") => 10000.0})
    end

    it "displays number of order for each food" do
      food = create(:food, name: "Food 1",  price: 10000.0)
      line_item = create(:line_item, quantity: 1, food: food)
      order = create(:order)
      order.line_items << line_item
      order.save

      get :index
      expect(Food.grouped_by_order).to eq({"Food 1" => 1})
    end

    it "displays total price of order for each food" do
      food = create(:food, name: "Food 1",  price: 10000.0)
      line_item = create(:line_item, quantity: 1, food: food)
      order = create(:order)
      order.line_items << line_item
      order.save

      get :index
      expect(Food.grouped_by_total_price).to eq({"Food 1" => 10000.0})
    end

    it "displays number of order from each restaurant" do
      restaurant = create(:restaurant, name: "Restaurant 1")
      food = create(:food, name: "Food 1",  price: 10000.0, restaurant: restaurant)
      line_item = create(:line_item, quantity: 1, food: food)
      order = create(:order)
      order.line_items << line_item
      order.save

      get :index
      expect(Restaurant.grouped_by_order).to eq({"Restaurant 1" => 1})
    end

    it "displays total price of order from each restaurant" do
      restaurant = create(:restaurant, name: "Restaurant 1")
      food = create(:food, name: "Food 1",  price: 10000.0, restaurant: restaurant)
      line_item = create(:line_item, quantity: 1, food: food)
      order = create(:order)
      order.line_items << line_item
      order.save

      get :index
      expect(Restaurant.grouped_by_total_price).to eq({"Restaurant 1" => 10000.0})
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end