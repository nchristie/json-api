require 'rails_helper'

describe ProductUpdater do

  let(:product) { FactoryGirl.create(:product) }

  describe "#update!" do
    it "requires a product - raises if no valid product_id given" do
      params = { "a" => 1 }
      expect { described_class.new(nil, params).update! }.to raise_error ProductUpdater::NoProductFoundForId
    end

    it "renders errors if the params are not valid" do
      params = { "ad" => 1 }

      expect{ described_class.new(product, params).update! }
        .to raise_error ProductUpdater::InvalidParams
    end

    it "renders all errors if there are multiple issues" do
      # TODO
    end

    it "saves the product if everything is valid" do
      product = FactoryGirl.create(:product)
      params = { "id" => product.id, "price" => 2 }

      described_class.new(product.id, params).update!
      product.reload
      expect(product.price).to eq 2
    end
  end
end