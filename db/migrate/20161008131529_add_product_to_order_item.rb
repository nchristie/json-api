class AddProductToOrderItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_items, :product, index: true, foreign_key: true
  end
end
