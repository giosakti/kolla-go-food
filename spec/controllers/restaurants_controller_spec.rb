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