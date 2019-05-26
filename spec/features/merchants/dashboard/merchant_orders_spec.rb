require "rails_helper"
# As a merchant
# When I visit my dashboard ("/dashboard")
# If any users have pending orders containing items I sell
# Then I see a list of these orders.
# Each order listed includes the following information:
# - the ID of the order, which is a link to the order show page ("/dashboard/orders/15")
# - the date the order was made
# - the total quantity of my items in the order
# - the total value of my items for that order
RSpec.describe 'As a merchant: ' do
  describe "when I visit my dashboard, " do
    before :each do
      @merchant = create(:merchant)
      @other_merchant = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit merchant_dashboard_path
    end
    it "I see a list of pending orders with only items I sell" do
      
    end
  end
end
