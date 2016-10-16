require 'rails_helper'

RSpec.describe Promotion, :type => :model do
  it { should belong_to(:category) }
  it { should belong_to(:product) }
  it { should have_many(:orders) }
end
