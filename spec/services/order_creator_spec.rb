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

  before { Promotion.create!(code: "123", promotion_type: "fixed", discount: 2) }


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

      it "creates an order with the correct fields corectly calculating the total" do
        expect(order.order_items.size).to eq 2
        expect(order.order_items.first.product_id).to eq product_1.id
        expect(order.order_items.last.product_id).to eq product_2.id
        expect(order.order_items.last.price).to eq product_2.price

        expect(order.total).to eq 6
      end

      context "it applies a discount code when a valid code is passed" do
        let(:params_with_promo) do
          {
            :user_id=>47,
            :promotion_code=> "123",
            :order_items=> [
              {:product_id=>product_1.id, :quantity=>2},
              {:product_id=>product_2.id, :quantity=>4}
             ]
          }.with_indifferent_access
        end

        subject { described_class.new(user, params_with_promo) }

        let!(:order) { subject.publish! }

        it "calculates the order total correctly given a discount" do
          # Expect total before discount to be 6, expect total after discount to be 4
          expect(order.total).to eq 4
        end
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

      context "promotion code is not valid" do
        let(:params_with_invalid_promo) do
          {
            :user_id=>47,
            :promotion_code=> "code_does_not_exist",
            :order_items=> [
              {:product_id=>product_1.id, :quantity=>2},
              {:product_id=>product_2.id, :quantity=>4}
             ]
          }.with_indifferent_access
         end

        subject { described_class.new(user, params_with_invalid_promo) }
        let!(:order) { subject.publish! }

        it "creates an order with the correct fields" do
          expect(order.errors.messages).to have_key(:base)
          expect(order.errors.messages[:base]).to eq ["The Promo code provided is invalid."]
        end
      end
    end
  end
end