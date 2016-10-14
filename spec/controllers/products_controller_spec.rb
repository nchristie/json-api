require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do

  let(:params) do
    { format: :json }
  end

  let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  before { allow(controller).to receive(:user).and_return(user) }

  let!(:category) { FactoryGirl.create(:category, id: 1) }

  let!(:product_1) { FactoryGirl.create(:product, id: 1) }
  let!(:product_2) { FactoryGirl.create(:product, id: 2) }

  let(:valid_attributes) do
    {
       "name" => "product1",
       "price" => 1,
       "category_id" => 1,
       "stock_quantity" => 123
    }
  end

  describe "GET #index" do
    render_views

    it  "returns a list of products" do
      get :index, params
      expect(response.code).to eq "200"
      result = JSON.parse(response.body)

      product = result.first
      expect(product["id"]).to eq 1
      expect(product["name"]).to eq product_1.name
      expect(product["stock_quantity"]).to eq 1
      expect(product["url"]).to eq "http://test.host/products/1.json"

      product = result.last
      expect(product["id"]).to eq 2
      expect(product["name"]).to eq product_2.name
      expect(product["stock_quantity"]).to eq 1
      expect(product["url"]).to eq "http://test.host/products/2.json"
    end
  end

  describe "GET #show" do
    render_views

    it "returns not found if the product does not exist" do
      params[:id] = 999

      get :show, params
      expect(response.code).to eq "404"

      result = JSON.parse(response.body)

      puts result

      expect(result).to eq({
        "error" => {
          "message" => "Couldn't find Product with 'id'=999"
        }
      })
    end

    it "returns infomation about the product when it is found" do
      params[:id] = 1
      get :show, params

      expect(response.code).to eq "200"

      puts response

      result = JSON.parse(response.body)

      puts result

      expect(result["id"]).to eq 1
      expect(result["name"]).to eq product_1.name
      expect(result["stock_quantity"]).to eq product_1.stock_quantity
      expect(result["price"]).to eq product_1.price
    end
  end

  describe "POST #create" do

    let!(:params) do
        {
          :name => "test_product_with_images",
          :price => 1,
          :category_id => category.id,
          :stock_quantity => 123,
          :images => [
                       { :data => "testing-image-1" },
                       { :data => "testing-image-2" }
                     ],
          format: :json
        }.with_indifferent_access
    end

    context "successful request" do
      it "creates a new Product and an associated image record" do
        expect { post :create, params }.to change(Product, :count).by(1)
        expect { post :create, params }.to change(Image, :count).by(2)
      end

      it "responds with product information when the product creation is successful" do
        post :create, params

        puts response.body

        expect(response.code).to eq "201"

        product = Product.last

        expect(product.category_id).to eq 1
        expect(product.name).to eq "test_product_with_images"
        expect(product.price).to eq 1
        expect(product.stock_quantity).to eq 123

        expect(product.images).to be_a ActiveRecord::Associations::CollectionProxy

        expect(product.images.first.data).to eq "testing-image-1"
        expect(product.images.last.data).to eq "testing-image-2"
      end
    end

    context "with invalid params" do
      let(:invalid_product_params) do
          {
            :name => "test_product",
            format: :json
          }.with_indifferent_access
      end

      it "renders an informative error if required attributes are missing" do
        message = "Payload missing required keys: price, category_id, stock_quantity, images"
        expect { post :create, invalid_product_params }.to raise_error(message)
      end

      context "xtx" do

      let(:zero_price_params) do
        {
          :name => "test_product_with_images",
          :price => 0,
          :category_id => category.id,
          :stock_quantity => 123,
          :images => [
                       { :data => "testing-image-1" },
                       { :data => "testing-image-2" }
                     ],
          format: :json
        }.with_indifferent_access
      end

      it "renders an informative error if required attributes are included but the price is zero" do
        message = "Please ensure your product has a price greater than zero."
        expect { post :create, zero_price_params }.to raise_error(message)
      end
      end
    end
  end
end
