class AddProductToImages < ActiveRecord::Migration[5.0]
  def change
    add_reference :images, :product, index: true, foreign_key: true
  end
end
