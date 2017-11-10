json.extract! tag, :id, :name, :description, :image_url, :price, :created_at, :updated_at
json.url category_url(tag, format: :json)
