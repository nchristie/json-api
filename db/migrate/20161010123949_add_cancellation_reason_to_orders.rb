class AddCancellationReasonToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cancellation_reason, :string
  end
end
