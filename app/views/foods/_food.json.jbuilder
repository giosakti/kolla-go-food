json.extract! food, :id, :name, :description, :image_url, :price, :created_at, :updated_at
json.url category_url(food, format: :json)
