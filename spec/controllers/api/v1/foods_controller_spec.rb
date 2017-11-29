require 'rails_helper'

describe Api::V1::FoodsController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id

    @food = create(:food, price: 10000)
  end
    
  describe 'GET #index' do
    before :each do
      @searched_food1 = create(:food, name: "Ayam Rica-Rica", description: "Ayam", price: 15000)
      @searched_food2 = create(:food, name: "Steak Ayam BBQ", description: "Steak", price: 25000)
      @searched_food3 = create(:food, name: "Nasi Goreng Ayam", description: "Nasi Goreng", price: 35000)
    end

    context 'with params[:letter]' do
      it "populates an array of foods starting with the letter" do
        get :index, params: { letter: 'N' }, format: 'json'
        expect(assigns(:foods)).to match_array([@searched_food3])
      end
    end

    context 'without params[:letter]' do
      it "populates an array of all foods" do 
        get :index, format: 'json'
        expect(assigns(:foods)).to match_array([@food, @searched_food1, @searched_food2, @searched_food3])
      end
    end

    describe 'with search parameters' do
      it "can be searched by name" do
        get :index, params: { search: { name_like: 'ayam' } }, format: 'json'
        expect(assigns(:foods)).to match_array([@searched_food1, @searched_food2, @searched_food3])
      end

      it "can be searched by description" do
        get :index, params: { search: { description_like: 'ayam' } }, format: 'json'
        expect(assigns(:foods)).to match_array([@searched_food1])
      end

      it "can be searched by minimum_price" do
        get :index, params: { search: { minimum_price: 20000 } }, format: 'json'
        expect(assigns(:foods)).to match_array([@searched_food2, @searched_food3])
      end

      it "can be searched by maximum_price" do
        get :index, params: { search: { maximum_price: 30000 } }, format: 'json'
        expect(assigns(:foods)).to match_array([@food, @searched_food1, @searched_food2])
      end
    end
  end

  describe 'GET #show' do
    it "assigns the requested food to @food" do
      get :show, params: { id: @food }, format: 'json'
      expect(assigns(:food)).to eq @food
    end
  end
end