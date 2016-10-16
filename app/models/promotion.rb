class Promotion < ApplicationRecord
  belongs_to :category
  belongs_to :product
  has_many :orders
end
