class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :product

  # Association validations
  validates_presence_of :product
  validates_presence_of :order

  # Attribute validations
  validates_presence_of :quantity, message: "Please enter a quantity"
end
