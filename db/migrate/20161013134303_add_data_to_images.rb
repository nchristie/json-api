class AddDataToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :data, :string
  end
end
