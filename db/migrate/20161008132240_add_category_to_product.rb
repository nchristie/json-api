class AddCategoryToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :category, index: true, foreign_key: true
  end
end
