class AddAttributesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :in_stock, :boolean, default: true
    add_column :products, :stock_quantity, :integer, default: 0, null: false
  end
end
