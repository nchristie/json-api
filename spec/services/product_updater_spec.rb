require 'rails_helper'

describe ProductUpdater do

  describe "#update!" do
    it "requires a product" do
      params = { "a" => 1 }
      expect { described_class.new(nil, params).update! }.to raise_error ProductUpdater::NoProductFoundForId
    end

    it "renders errors if a product is not found" do

    end

    it "renders errors if the params are not valid" do

    end

    it "renders all if there are multiple issues" do

    end

    it "saves the product if everything is valid" do
      product = FactoryGirl.create(:product)
      params = { "id" => product.id, "price" => 2 }

      described_class.new(product.id, params).update!

      expect(product.price).to eq 2
    end
  end



end