require 'rails_helper'

describe OrderCreator do

  let!(:user) { User.create!(name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:category) { FactoryGirl.create(:category) }

  let!(:product_1) { FactoryGirl.create(:product) }
  let!(:product_2) { FactoryGirl.create(:product) }

  let(:order_with_items) { FactoryGirl.create(:order_with_items) }

  let(:params) {
    order_with_items.attributes.merge(
      order_items: [
        {:product_id => product_1.id, :quantity => 2},
        {:product_id => product_2.id, :quantity => 4}
      ]
    ).with_indifferent_access
  }

  describe "#successful?" do
    subject { described_class.new(user, params) }

    let!(:order) { subject.publish! }

    it "the order is persisted & free of errors" do
      expect(order).to be_persisted
      expect(order.errors).to be_empty

      expect(subject).to be_successful
    end
  end

  describe "#publish!" do

    context "when successful" do
      subject { described_class.new(user, params) }

      let!(:order) { subject.publish! }

      it "creates an order with the correct fields" do
        puts order.inspect
        puts order.order_items
        expect(order.order_items.size).to eq 2
        expect(order.order_items.first.product_id).to eq product_1.id
        expect(order.order_items.last.product_id).to eq product_2.id
        expect(order.order_items.last.price).to eq product_2.price
      end
    end

    context "when unsuccessful" do
      context "no product given" do
        let(:params) {
          order_with_items.attributes.merge(
            order_items: []
          ).with_indifferent_access
        }

        subject { described_class.new(user, params) }

        let!(:order) { subject.publish! }

        it "shows an appropriate error message when no product is given" do
          expect(order.errors.messages).to have_key(:base)
          expect(order.errors.messages[:base]).to eq ["Please provide a minimum of one Order Item/Product with your order"]
        end
      end

      context "invalid/nonexistent product given" do
        let(:params) {
          order_with_items.attributes.merge(
            order_items: [
              {:product_id => 999, :quantity => 2}
            ]
          ).with_indifferent_access
        }

        subject { described_class.new(user, params) }

        let!(:order) { subject.publish! }

        it "shows an appropriate error message when no product is given" do
          expect(order.errors.messages).to have_key(:base)
          expect(order.errors.messages[:base]).to eq ["This Product does not exist."]
        end
      end
    end
  end
end