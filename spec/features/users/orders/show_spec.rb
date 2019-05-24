
# When I visit my Profile Orders page
# And I click on a link for order's show page
# My URL route is now something like "/profile/orders/15"
# I see all information about the order, including the following information:
# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item I ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order

require "rails_helper"

describe "as a registered user" do

  before :each do
    @user_1 = User.create!(email: "user_1@gmail.com", role: 2, name: "User 1", address: "User 1 Address", city: "User 1 City", state: "User 1 State", zip: "12345", password: "123456")
    @user_2 = User.create!(email: "user_2@gmail.com", role: 2, name: "User 2", address: "User 2 Address", city: "User 2 City", state: "User 2 State", zip: "22345", password: "123456")

    @user_8 = User.create!(email: "user_8@gmail.com", role: 0, name: "User 8", address: "User 8 Address", city: "User 8 City", state: "User 8 State", zip: "82345", password: "123456")

    @item_1 = @user_1.items.create!(name: "Item 1", active: true, price: 1.00, description: "Item 1 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 10)
    @item_2 = @user_2.items.create!(name: "Item 2", active: true, price: 2.00, description: "Item 2 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 15)
    @item_3 = @user_2.items.create!(name: "Item 3", active: true, price: 3.00, description: "Item 3 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 20)

    @order_1 = @user_8.orders.create!(status: 3)
    @order_2 = @user_8.orders.create!(status: 2)

    @order_item_1 = @order_1.order_items.create!(item_id: @item_1.id, quantity: 1, price: 1.00, fulfilled: true)
    @order_item_2 = @order_2.order_items.create!(item_id: @item_1.id, quantity: 1, price: 1.00, fulfilled: true)
    @order_item_3 = @order_2.order_items.create!(item_id: @item_2.id, quantity: 2, price: 4.00, fulfilled: true)
    @order_item_4 = @order_1.order_items.create!(item_id: @item_1.id, quantity: 1, price: 1.00, fulfilled: true)
    @order_item_5 = @order_2.order_items.create!(item_id: @item_2.id, quantity: 2, price: 4.00, fulfilled: true)

    visit root_path

    click_on "LogIn"

    expect(current_path).to eq(login_path)
    fill_in "email", with: @user_8.email
    fill_in "password", with: @user_8.password

    click_on "Log In"
  end

  it "has an item show page" do
    visit profile_order_path(@order_2)
    expect(page).to have_content("Order: #{@order_2.id}")
    expect(page).to have_content("Placed: #{@order_2.created_at.to_date}")
    expect(page).to have_content("Placed: #{@order_2.updated_at.to_date}")
    expect(page).to have_content("Status: #{@order_2.status}")
    expect(page).to have_content("Number of Items: #{@order_2.total_item_count}")
    expect(page).to have_content("Total Cost: #{@order_2.total_price}")

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.description)
    end
  end

end
