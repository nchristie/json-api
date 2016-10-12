class AddProductToImageUrls < ActiveRecord::Migration[5.0]
  def change
    add_reference :image_urls, :product, index: true, foreign_key: true
  end
end
