class Promotion < ApplicationRecord
  # belongs_to :category
  # belongs_to :product
  has_many :orders

  # I.e. discount on a percentate basis or a fixed amount.
  PROMOTION_TYPES = %w(percentage fixed).freeze

  validates_inclusion_of :promotion_type, in: PROMOTION_TYPES, allow_blank: false
end
