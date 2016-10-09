class AddAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :email, :string, null: false
    add_column :users, :type, :string
  end
end
