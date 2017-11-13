class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable
  validates :name, presence: true, uniqueness: true

  scope :grouped_by_order, -> { joins(foods: { line_items: :order }).group("restaurants.name").count }
  scope :grouped_by_total_price, -> { joins(foods: { line_items: :order }).group("restaurants.name").sum("orders.total_price") }

  def self.search(params)
    restaurants = self.all
    
    restaurants = restaurants.where("LOWER(name) LIKE ?", "%#{params[:name_like].downcase}%") if self.valid_search_params?(params[:name_like])
    restaurants = restaurants.where("LOWER(address) LIKE ?", "%#{params[:address_like].downcase}%") if self.valid_search_params?(params[:address_like])
    restaurants = restaurants.where("foods_count >= ?", params[:minimum_foods_count]) if self.valid_search_params?(params[:minimum_foods_count])
    restaurants = restaurants.where("foods_count <= ?", params[:maximum_foods_count]) if self.valid_search_params?(params[:maximum_foods_count])

    restaurants
  end

  def self.valid_search_params?(params)
    params.present? && !params.blank?
  end
end
