class ChangeTotalOnOrders < ActiveRecord::Migration[5.0]
  def change
    change_column_default :orders, :total, 0
  end
end
