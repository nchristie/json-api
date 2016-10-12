require 'rails_helper'

describe OrderManager do

  describe ".user_cancel" do
    let(:order) { FactoryGirl.create(:order_with_items) }
    let(:reason) { "I changed my mind!" }

    it 'marks order as cancelled and logs the reason' do
      expect(OrderManager.user_cancel(order, reason)).to be_truthy

      order.reload

      expect(order.state).to eq "cancelled"
      expect(order.cancellation_reason).to eq "I changed my mind!"
    end
  end
end