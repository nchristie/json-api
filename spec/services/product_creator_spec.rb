require 'rails_helper'

describe ProductCreator do

  let!(:user) { User.create!(name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }
  let!(:category) { FactoryGirl.create(:category) }

  let(:params) do
    {
      :name => "product12345",
      :price => 1,
      :category_id => Category.last.id,
      :stock_quantity => 123,
      :images => [{}]
    }
  end

  subject { described_class.new(params) }

  describe "#publish!" do
    context "when successful" do
      it "creates a product with the correct attributes" do
        subject.publish!

        created_product = Product.last

        expect(created_product.name).to eq "product12345"
        expect(created_product.price).to eq 1
        expect(created_product.category).to eq category
        expect(created_product.stock_quantity).to eq 123

        # TODO - Actually create an image
        #expect(created_product.images).to eq
      end
    end

    context "when unnsuccessful" do
      it "fails if the product cannot be saved" do
        # In this spec we fail on a validation. +product.name+ cannot be nil.
        params[:name] = nil
        expect(subject.publish!).to eq false
      end
    end
  end
end