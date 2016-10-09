json.extract! product, :id, :name, :stock_quantity, :price
json.url product_url(product, format: :json)
