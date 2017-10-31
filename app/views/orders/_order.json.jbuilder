json.extract! order, :id, :name, :description, :image_url, :price, :created_at, :updated_at
json.url order_url(order, format: :json)
