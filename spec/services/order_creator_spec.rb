require 'rails_helper'

describe OrderCreator do

  let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:category) { FactoryGirl.create(:category, id: 1) }

  let!(:product_1) { FactoryGirl.create(:product, id: 1) }
  let!(:product_2) { FactoryGirl.create(:product, id: 2) }

  let(:order_with_items) { FactoryGirl.create(:order_with_items) }

  let(:params) {
    order_with_items.attributes.merge(
      order_items: [
        {:product_id => 1, :quantity => 2},
        {:product_id => 2, :quantity => 4}
      ]
    ).with_indifferent_access
  }

  describe "#successful?" do
    subject { described_class.new(user, params) }

    let!(:order) { subject.publish! }

    it "the order is persisted & free of errors" do
      # These 2 to be removed.
      expect(order).to be_persisted
      expect(order.errors).to be_empty

      expect(subject).to be_successful
    end
  end

  describe "#publish!" do
    subject { described_class.new(user, params) }

    let!(:order) { subject.publish! }

    it "creates an order with the correct fields" do
      expect(subject).to be_successful

      puts "-----------"
      puts order.errors
      puts order.persisted?
      puts "-----------"

      expect(order.order_items.size).to eq 2

      expect(order.order_items.first.product_id).to eq product_1.id
      expect(order.order_items.last.product_id).to eq product_2.id
    end
  end
end