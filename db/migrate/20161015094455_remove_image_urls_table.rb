class RemoveImageUrlsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :image_urls
  end
end
