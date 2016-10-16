class Product < ApplicationRecord
  #Associations
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :images
  has_many :promotions

  # Association validations
  validates_presence_of :category

  # Attribute validations
  validates_presence_of :name, message: "Please add a product name."
  validates_presence_of :price, message: "Please add a price."
end
