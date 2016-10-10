class AddStateToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :state, :string, default: "confirmed", null: false
  end
end