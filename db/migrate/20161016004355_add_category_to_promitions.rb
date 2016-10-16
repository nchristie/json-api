class AddCategoryToPromitions < ActiveRecord::Migration[5.0]
  def change
    add_reference :promotions, :category, index: true, foreign_key: true
  end
end
