require 'rails_helper'

RSpec.describe "As a user," do
  describe "when I visit my cart" do
    before :each do
      @user = User.create!(email: "bob@bob.com", password: "124355", name: "bob", address:"123 bob st.", city: "bobton", state:"MA", zip: 28234)
      @itemA = @user.items.create!(name: "Item 1", price: 1.00, description: "Item 1 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 10)
      @itemB = @user.items.create!(name: "Item 2", price: 2.00, description: "Item 2 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 11)
      @itemC = @user.items.create!(name: "Item 3", price: 2.50, description: "Item 3 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 12)
    end

    it "I see something telling me it's empty (if it's empty)" do
      visit "/cart"

      expect(page).to have_content("Your cart is empty.")
    end

    it "I can add an item to my cart" do
      visit "/items/#{@itemA.id}"
      page.select '2', from: :quantity
      click_on "Add to Cart"

      expect(current_path).to eq("/items/#{@itemA.id}")
      expect(session[:cart].contents).to eq({@itemA.id => 2})
    end

    it "I see a list of items and quantities" do

    end
  end
end