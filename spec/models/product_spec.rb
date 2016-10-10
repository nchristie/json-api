require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:category) }
  it { should have_many(:order_items) }
  it { should have_many(:orders).through(:order_items) }
  it { should have_many(:images) }

  it { should validate_presence_of(:category) }

  it { should validate_presence_of(:name).with_message("Please add a product name.") }
  it { should validate_presence_of(:price).with_message("Please add a price.") }
end
