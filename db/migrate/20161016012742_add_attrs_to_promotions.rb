class AddAttrsToPromotions < ActiveRecord::Migration[5.0]
  def change
    add_column :promotions, :name, :string
    add_column :promotions, :code, :string
    add_column :promotions, :discount, :integer
  end
end
