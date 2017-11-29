class Api::V1::FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  # GET /foods
  # GET /foods.json
  def index
    if !params[:search].nil?
      @foods = Food.search(params[:search])
    elsif !params[:letter].nil?
      @foods = Food.by_letter(params[:letter])
    else
      @foods = Food.all
    end

    respond_to do |format|
      format.json { render json: @foods }
    end
  end

  # GET /foods/1
  # GET /foods/1.json
  def show
    respond_to do |format|
      format.json { render json: @food }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :description, :image_url, :price, :category_id, :restaurant_id, tag_ids: [])
    end
end
