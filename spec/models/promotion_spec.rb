require 'rails_helper'

RSpec.describe Promotion, :type => :model do
  it { should have_many(:orders) }

  context "valid types" do
    it "is not valid with type outside #{Promotion::PROMOTION_TYPES}" do
      expect { Promotion.create!(promotion_type: "xyz") }.to raise_error "Validation failed: Promotion type is not included in the list"
    end
  end
end
