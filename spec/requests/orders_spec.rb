require 'rails_helper'

RSpec.describe "Make Order and then view status", :type => :request do
  let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:category) { FactoryGirl.create(:category, id: 1) }

  let!(:product_1) { FactoryGirl.create(:product, id: 1) }
  let!(:product_2) { FactoryGirl.create(:product, id: 2) }

  let(:order_with_items) { FactoryGirl.create(:order_with_items) }

  let(:order_params) {
    order_with_items.attributes.merge(
      order_items: [
        {:product_id => 1, :quantity => 2},
        {:product_id => 2, :quantity => 4}
      ]
    ).with_indifferent_access
  }

  context "successful flow" do
    it "creates an order, provides the location header & then allows the user to view it" do
      Timecop.freeze(DateTime.new(2016, 1, 1, 12, 0, 0))

      post orders_path, order_params.to_json,
      {
        "Content-Type"  => "application/json",
        "Authorization" => "Token #{user.access_token}"
      }

      expect(response).to be_success

      location = response.headers["Location"]

      order = Order.last

      id = location.match(/\/[0-9]+/).to_s[1..-1]

      get "/orders/" + order.to_param, { format: :json },
      {
        "Content-Type"  => "application/json",
        "Authorization" => "Token #{user.access_token}"
      }

      result = JSON.parse(response.body)

      expect(result).to eq(
        {"order" =>
          {
            "order_id" => id.to_i,
            "total"=>nil,
            "url"=>"http://www.example.com/orders/#{id}.json",
            "created_at"=> "2016-01-01T12:00:00.000Z",
            "order_items" => [
              {
               "name" => product_1.name,
               "quantity" => 2,
               "unit_price" => product_1.price
              },
              {
               "name" => product_2.name,
               "quantity" => 4,
               "unit_price" => product_2.price
              }
            ]
          }
        })
    end
  end
end
