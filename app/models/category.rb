class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  # Attribute validations
  validates_presence_of :name, message: "Please add a name."
end
