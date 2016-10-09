json.order_id order.id
json.total order.total
json.url order_url(order, format: :json)

json.created_at order.created_at

json.order_items order.order_items do |order_item|
  json.name order_item.product.name
  json.quantity order_item.quantity
  json.unit_price order_item.product.price
end
