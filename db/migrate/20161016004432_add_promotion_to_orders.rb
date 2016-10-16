class AddPromotionToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :promotion, index: true, foreign_key: true
  end
end
