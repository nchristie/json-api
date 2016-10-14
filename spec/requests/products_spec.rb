require 'rails_helper'

RSpec.describe "Create a product with associated images and view it", :type => :request do
  let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:category) { FactoryGirl.create(:category, id: 1) }

  let!(:product_params) do
    {
      name: "test_product_with_images",
      price: 1,
      category_id: category.id,
      stock_quantity: 123,
      images: [
                { :data => "testing-image-1" },
                { :data => "testing-image-2" }
              ]
    }.with_indifferent_access
  end

  context "successful flow" do
    it "creates a product, provides the location header & then allows the user to view it immediately" do
      Timecop.freeze(DateTime.new(2016, 1, 1, 12, 0, 0))

      post products_path, product_params.to_json,
      {
        "Content-Type"  => "application/json",
        "Authorization" => "Token #{user.access_token}"
      }

      expect(response).to be_success

      location = response.headers["Location"]

      product = Product.last

      id = location.match(/\/[0-9]+/).to_s[1..-1]

      get "/products/" + product.to_param, { format: :json },
      {
        "Content-Type"  => "application/json",
        "Authorization" => "Token #{user.access_token}"
      }

      result = JSON.parse(response.body)

      expect(result).to eq(
        {
          "id" => 98,
          "name" => "test_product_with_images",
          "stock_quantity" => 123,
          "price" => 1,
          "url" => "http://www.example.com/products/98.json",
          "images" => [
                        {
                          "created_at" => "2016-01-01T12:00:00.000Z",
                          "data" => "testing-image-1"
                        },
                        {
                          "created_at" => "2016-01-01T12:00:00.000Z",
                          "data" => "testing-image-2"
                        }
                      ]
         }
      )
    end
  end
end
