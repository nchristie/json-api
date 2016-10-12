class AddImageToImageUrls < ActiveRecord::Migration[5.0]
  def change
    add_reference :image_urls, :image, index: true, foreign_key: true
  end
end
