require 'rails_helper'

describe OrdersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end
  
  describe 'GET #index' do
    it "populates an array of all orders" do 
      order1 = create(:order, name: "Buyer 1")
      order2 = create(:order, name: "Buyer 2")
      get :index
      expect(assigns(:orders)).to match_array([order1, order2])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end

    describe 'with search parameters' do
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
        get :index, params: { search: { name_like: 'iqbal' } }
        expect(assigns(:orders)).to match_array([@searched_order1, @searched_order3])
      end

      it "can be searched by address" do
        get :index, params: { search: { address_like: 'bekasi' } }
        expect(assigns(:orders)).to match_array([@searched_order2])
      end

      it "can be searched by email" do
        get :index, params: { search: { email_like: 'farabi' } }
        expect(assigns(:orders)).to match_array([@searched_order1, @searched_order2])
      end

      it "can be searched by minimum total price" do
        get :index, params: { search: { minimum_total_price: 15000 } }
        expect(assigns(:orders)).to match_array([@searched_order2, @searched_order3])
      end

      it "can be searched by maximum total price" do
        get :index, params: { search: { maximum_total_price: 25000 } }
        expect(assigns(:orders)).to match_array([@searched_order1, @searched_order2])
      end
    end
  end

  describe 'GET #show' do
    it "assigns the requested order to @order" do
      order = create(:order)
      get :show, params: { id: order }
      expect(assigns(:order)).to eq order
    end

    it "renders the :show template" do
      order = create(:order)
      get :show, params: { id: order }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context "with non-empty cart" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
        @line_item = create(:line_item, cart: @cart)
      end

      it "assigns a new Order to @order" do
        get :new
        expect(assigns(:order)).to be_a_new(Order)
      end

      it "renders the :new template" do
        get :new
        expect(:response).to render_template :new
      end
    end

    context "with empty cart" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
      end

      it "redirects to the store index page" do
        get :new
        expect(:response).to redirect_to store_index_url
      end
    end
  end

  describe 'GET #edit' do
    it "assigns the requested order to @order" do
      order = create(:order)
      get :edit, params: { id: order }
      expect(assigns(:order)).to eq order
    end

    it "renders the :edit template" do
      order = create(:order)
      get :edit, params: { id: order }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
      end

      it "saves the new order in the database" do
        expect{
          post :create, params: { order: attributes_for(:order) }
        }.to change(Order, :count).by(1)
      end

      it "destroys session's cart" do
        expect{
          post :create, params: { order: attributes_for(:order) }
        }.to change(Cart, :count).by(-1)
      end

      it "removes the cart from session's params" do
        post :create, params: { order: attributes_for(:order) }
        expect(session[:cart_id]).to eq(nil)
      end

      it "sends order confirmation email" do
        post :create, params: { order: attributes_for(:order) }
        expect { 
          OrderMailer.received((assigns(:order))).deliver 
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to store index page" do
        post :create, params: { order: attributes_for(:order) }
        expect(response).to redirect_to store_index_url
      end
    end

    context "with invalid attributes" do
      it "does not save the new order in the database" do
        expect{
          post :create, params: { order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @order = create(:order)
    end

    context "with valid attributes" do
      it "locates the requested @order" do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(assigns(:order)).to eq @order
      end

      it "changes @order's attributes" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: 'Buyer 1') }
        @order.reload
        expect(@order.name).to eq('Buyer 1')
      end

      it "redirects to the order" do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(response).to redirect_to @order
      end
    end

    context "with invalid attributes" do
      it "does not update the order in the database" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: 'Buyer 1', address: nil) }
        @order.reload
        expect(@order.name).not_to eq('Buyer 1')
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @order, order: attributes_for(:invalid_order) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @order = create(:order)
    end

    it "deletes the order from the database" do
      expect{
        delete :destroy, params: { id: @order }
      }.to change(Order, :count).by(-1)
    end

    it "redirects to orders#index" do
      delete :destroy, params: { id: @order }
      expect(response).to redirect_to orders_url
    end
  end
end