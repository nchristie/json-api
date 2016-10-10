class Order < ApplicationRecord
  belongs_to :user, inverse_of: :orders
  has_many :order_items, inverse_of: :order, dependent: :destroy
  has_many :products, through: :order_items

  scope :from_user, -> (user) { where(user_id: user.id) }
  scope :cancellable, -> { where(state: "confirmed") }

  VALID_STATES = %w(confirmed cancelled)

  #State
  state_machine :state, :initial => :confirmed do
    state :confirmed, :cancelled

    event :cancel_order do
      transition :confirmed => :cancelled
    end
  end

end
