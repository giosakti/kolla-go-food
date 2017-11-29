class FoodSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :price
  belongs_to :category
  belongs_to :restaurant
end
