require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  let!(:user) { User.create!(name: "test", email: "test@test.com", access_token: "e0b466508d4dcdf459f7") }

  let!(:product) { FactoryGirl.create(:product) }
  let!(:image_1) { FactoryGirl.create(:image, product: product) }
  let!(:image_2) { FactoryGirl.create(:image, product: product) }

  before { allow(controller).to receive(:user).and_return(user) }

  describe "GET #index" do
    render_views

    it "returns all images related to the given product" do
      get :index, { product_id: product.id, format: :json }

      expect(response.code).to eq "200"

      result = JSON.parse(response.body)

      # TODO: Update this spec once view changes
      image = result.first
      expect(image).to have_key("created_at")
      expect(image).to have_key("data")

      image = result.second
      expect(image).to have_key("created_at")
      expect(image).to have_key("data")

    end
  end
end
