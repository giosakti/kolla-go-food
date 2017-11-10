class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    @restaurants = Restaurant.order(:name)
  end
end
