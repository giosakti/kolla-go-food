json.extract! voucher, :id, :name, :description, :image_url, :price, :created_at, :updated_at
json.url voucher_url(voucher, format: :json)
