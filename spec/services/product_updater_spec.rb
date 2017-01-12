require 'rails_helper'

describe ProductUpdater do

  let(:product) { FactoryGirl.create(:product) }

  describe "#update!" do
    it "requires a product - raises if no valid product_id given" do
      params = { "a" => 1 }
      expect { described_class.new(nil, params).update! }
        .to raise_error ProductUpdater::NoProductFoundForIdError
    end

    it "renders errors if the params are not valid" do
      product_id, params = product.id, { "ad" => 1 }

      expect { described_class.new(product_id, params).update! }
        .to raise_error ProductUpdater::InvalidParamsError
    end

    it "renders all errors if there are multiple issues" do
      product_id, params = product.id, { "ad" => 1, "price" => "string price" }

      described_class.new(product_id, params).update!

      expect(product.errors[:base]).to include /Some Error/
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