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
      :images => [{ :data => "some test data" }]
    }
  end

  subject { described_class.new(params) }

  describe "#publish!" do
    context "when successful" do
      context "with [:images][:data]" do
        it "creates a product with the correct attributes" do
          subject.publish!

          created_product = Product.last

          expect(created_product.name).to eq "product12345"
          expect(created_product.price).to eq 1
          expect(created_product.category).to eq category
          expect(created_product.stock_quantity).to eq 123

          expect(created_product.images.first).to be_persisted
          expect(created_product.images.first.data).to eq "some test data"
          expect(created_product.images.first.url).to eq nil
        end
      end

      context "with [:images][:url]" do
        let(:params) do
          {
            :name => "product12345",
            :price => 1,
            :category_id => Category.last.id,
            :stock_quantity => 123,
            :images => [{ :url => "http://www.images.com/image123" }]
          }
        end
        it "creates a product with the correct attributes when [:images][:url] is passed" do
          subject.publish!

          created_product = Product.last

          expect(created_product.name).to eq "product12345"
          expect(created_product.price).to eq 1
          expect(created_product.category).to eq category
          expect(created_product.stock_quantity).to eq 123

          expect(created_product.images.first).to be_persisted
          expect(created_product.images.first.data).to eq nil
          expect(created_product.images.first.url).to eq "http://www.images.com/image123"
        end
      end
    end

    context "when unnsuccessful" do
      it "fails if the product cannot be saved" do
        # In this spec we fail on a validation. +product.name+ cannot be nil.
        params[:name] = nil
        expect(subject.publish!).to eq false
      end

      it "raises an error an image is declared with a require parameter" do
        params[:images][0][:url] = nil
        params[:images][0][:data] = nil

        expect { subject.publish! }.to raise_error (ProductCreator::NoImageDataGiven)
      end
    end
  end
end