json.extract! product, :id, :name, :stock_quantity, :price
json.url product_url(product, format: :json)

json.images product.images do |image|
  json.created_at image.created_at
  json.data image.data
end
