class ReviewsController < ApplicationController
  before_action :load_reviewable
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.where(reviewable_id: @reviewable.id)
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @reviewable, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def load_reviewable
      if params[:food_id]
        @reviewable = Food.find_by(id: params[:food_id])
      elsif params[:restaurant_id]
        @reviewable = Restaurant.find_by(id: params[:restaurant_id])
      end
    end

    def review_params
      params.require(:review).permit(:reviewer_name, :title, :description, :reviewable_id, :reviewable_type)
    end
end
