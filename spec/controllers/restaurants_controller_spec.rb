require 'rails_helper'

describe RestaurantsController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
    
    @restaurant = create(:restaurant)
    @restaurant1 = create(:restaurant, name: "Restaurant 1")
    @restaurant2 = create(:restaurant, name: "Restaurant 2")
  end
    
  describe 'GET #index' do
    it "populates an array of all restaurants" do 
      get :index
      expect(assigns(:restaurants)).to match_array([@restaurant, @restaurant1, @restaurant2])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end

    describe 'with search parameters' do
      before :each do
        category = create(:category)
        
        @searched_restaurant1 = create(:restaurant, name: "Kopi Oei", address: "Sabang")
        @searched_restaurant1.foods.create(name: "Food 1", description: "Food 1", price: 10000, category_id: category.id)
        
        @searched_restaurant2 = create(:restaurant, name: "Anomali Kopi", address: "Setiabudi")
        @searched_restaurant2.foods.create(name: "Food 2", description: "Food 2", price: 10000, category_id: category.id)
        @searched_restaurant2.foods.create(name: "Food 3", description: "Food 3", price: 10000, category_id: category.id)
      end

      it "can be searched by name" do
        get :index, params: { search: { name_like: 'kopi' } }
        expect(assigns(:restaurants)).to match_array([@searched_restaurant1, @searched_restaurant2])
      end

      it "can be searched by address" do
        get :index, params: { search: { address_like: 'sabang' } }
        expect(assigns(:restaurants)).to match_array([@searched_restaurant1])
      end

      it "can be searched by minimum foods count" do
        get :index, params: { search: { minimum_foods_count: 2 } }
        expect(assigns(:restaurants)).to match_array([@searched_restaurant2])
      end

      it "can be searched by maximum foods count" do
        get :index, params: { search: { maximum_foods_count: 1 } }
        expect(assigns(:restaurants)).to match_array([@restaurant, @restaurant1, @restaurant2, @searched_restaurant1])
      end
    end
  end

  describe 'GET #show' do
    it "assigns the requested restaurant to @restaurant" do
      get :show, params: { id: @restaurant }
      expect(assigns(:restaurant)).to eq @restaurant
    end

    it "displays related reviews" do
      review1 = create(:restaurant_review, reviewable: @restaurant)
      review2 = create(:restaurant_review, reviewable: @restaurant)
      get :show, params: { id: @restaurant }
      expect(assigns[:restaurant].reviews).to match_array([review1, review2])
    end

    it "renders the :show template" do
      get :show, params: { id: @restaurant }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "assigns a new Restaurant to @restaurant" do
      get :new
      expect(assigns(:restaurant)).to be_a_new(Restaurant)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested restaurant to @restaurant" do
      get :edit, params: { id: @restaurant }
      expect(assigns(:restaurant)).to eq @restaurant
    end

    it "renders the :edit template" do
      get :edit, params: { id: @restaurant }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new restaurant in the database" do
        expect{
          post :create, params: { restaurant: attributes_for(:restaurant) }
        }.to change(Restaurant, :count).by(1)
      end

      it "redirects to restaurants#show" do
        post :create, params: { restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to(restaurant_path(assigns[:restaurant]))
      end
    end

    context "with invalid attributes" do
      it "does not save the new restaurant in the database" do
        expect{
          post :create, params: { restaurant: attributes_for(:invalid_restaurant) }
        }.not_to change(Restaurant, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { restaurant: attributes_for(:invalid_restaurant) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @restaurant" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant) }
        expect(assigns(:restaurant)).to eq @restaurant
      end

      it "changes @restaurant's attributes" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant, name: 'Custom Restaurant Name') }
        @restaurant.reload
        expect(@restaurant.name).to eq('Custom Restaurant Name')
      end

      it "redirects to the restaurant" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to @restaurant
      end
    end

    context "with invalid attributes" do
      it "does not update the restaurant in the database" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant, name: nil) }
        @restaurant.reload
        expect(@restaurant.name).not_to eq(nil)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:invalid_restaurant) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it "deletes the restaurant from the database" do
      expect{
        delete :destroy, params: { id: @restaurant }
      }.to change(Restaurant, :count).by(-1)
    end

    it "redirects to restaurants#index" do
      delete :destroy, params: { id: @restaurant }
      expect(response).to redirect_to restaurants_url
    end
  end
end