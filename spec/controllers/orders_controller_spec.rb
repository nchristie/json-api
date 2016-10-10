require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do

  let(:params) do
    { format: :json }
  end

  let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:order_1) { FactoryGirl.create(:order_with_items, id: 1) }
  let!(:order_2) { FactoryGirl.create(:order_with_items, id: 2) }

  before { allow(controller).to receive(:user).and_return(user) }

  describe "GET #index" do
    render_views

    it "returns a list of orders" do
      get :index, params

      expect(response.code).to eq "200"

      result = JSON.parse(response.body)

      order = result.first
      expect(order["order_id"]).to eq 1
      # Expand this spec

      order = result.second
      expect(order["order_id"]).to eq 2
      # Expand this spec
    end
  end

  describe "GET #show" do
    render_views

    it "returns not found if the order does not exist" do
      params[:id] = 999

      get :show, params
      expect(response.code).to eq "404"

      result = JSON.parse(response.body)

      expect(result).to eq({
        "error" => {
          "message" => "Couldn't find Order with 'id'=999"
        }
      })
    end

    it "returns infomation about the order when it is found" do
      params[:id] = 1
      get :show, params

      expect(response.code).to eq "200"

      result = JSON.parse(response.body)["order"]

      expect(result["order_id"]).to eq 1
      #Expand this spec
    end
  end

  describe "POST #create" do
    render_views

    context "with valid params" do
      let!(:user) { User.create!(id: 1, name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

      let!(:category) { FactoryGirl.create(:category, id: 1) }

      let!(:product_1) { FactoryGirl.create(:product, id: 1) }
      let!(:product_2) { FactoryGirl.create(:product, id: 2) }

      let(:order_with_items) { FactoryGirl.create(:order_with_items) }

      let(:params) {
        order_with_items.attributes.merge(
          order_items: [
            {:product_id => 1, :quantity => 2},
            {:product_id => 2, :quantity => 4}
          ]
        ).with_indifferent_access
      }


      it "creates a new Order" do
        puts params
        expect { post :create, params }.to change(Order, :count).by(1)
      end

      it "responds with order information when the order is successful" do
        post :create, params

        expect(response.code).to eq "201"

        order = Order.last

        expect(order.user_id).to eq 1

        expect(order.order_items.size).to eq 2
        expect(order.order_items.first.product.name).to eq product_1.name
        expect(order.order_items.last.product.name).to eq product_2.name

        #TODO: In next improvements.
        expect(order.total).to eq nil
      end
    end

    context "with invalid params" do
      let(:order_with_items) { FactoryGirl.create(:order_with_items) }

      let(:invalid_product_params) {
        order_with_items.attributes.merge(
          order_items: [ { "a" => 1 } ]
        ).with_indifferent_access
      }

      it "renders an informative error if product does not exist" do
        post :create, invalid_product_params
        expect(response.code).to eq "422"
        result = JSON.parse(response.body)
        expect(result).to have_key("base")
        expect(result["base"]).to eq ["This Product does not exist."]
      end

      let(:empty_order_items_params) {
        order_with_items.attributes.merge(
          order_items: [ {  } ]
        ).with_indifferent_access
      }

      it "renders errors when the order could not be created" do
        post :create, empty_order_items_params
        expect(response.code).to eq "422"

        result = JSON.parse(response.body)

        expect(result).to have_key("base")
        expect(result["base"]).to eq ["param is missing or the value is empty: order_items"]
      end
    end
  end
end
