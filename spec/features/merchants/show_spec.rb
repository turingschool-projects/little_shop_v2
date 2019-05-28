require 'rails_helper'
describe "as a merchant" do
  describe "when I visit my dashboard page" do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @user_1 = create(:user)

      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_1)
      @item_4 = create(:item, user: @merchant_2)

      @order_1 = create(:pending, user: @user_1)
      @order_2 = create(:pending, user: @user_1)
      @order_3 = create(:pending, user: @user_1)
      @order_4 = create(:packaged, user: @user_1)

      @order_item_1 = create(:order_item, order: @order_1, item: @item_1)
      @order_item_2 = create(:order_item, order: @order_1, item: @item_2)
      @order_item_3 = create(:order_item, order: @order_2, item: @item_2)
      @order_item_4 = create(:order_item, order: @order_2, item: @item_3)
      @order_item_5 = create(:order_item, order: @order_2, item: @item_4)
      @order_item_6 = create(:order_item, order: @order_3, item: @item_4)
      @order_item_7 = create(:order_item, order: @order_4, item: @item_1)

      @merchant = create(:merchant, email: "m1@gmail.com")
      @itemA = @merchant.items.create!(name: "Item 1", price: 1.00, description: "Item 1 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 10, active: true)
      @itemB = @merchant.items.create!(name: "Item 2", price: 2.00, description: "Item 2 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 11, active: false)
      @itemC = @merchant.items.create!(name: "Item 3", price: 2.50, description: "Item 3 Description", image: "https://tradersofafrica.com/img/no-product-photo.jpg", inventory: 12, active: true)
      @user1 = create(:user, email: "u1@gmail.com")
    end

    it "does not display for visitors or users" do
      visit root_path
      expect(page).to have_no_link("Dashboard")

      click_link "Login"
      fill_in 'email', with: @user1.email
      fill_in 'password', with: @user1.password
      click_button "Log In"

      visit root_path
      expect(page).to have_no_link("Dashboard")
    end

    it "shows all the stuff it should" do
      visit root_path

      click_link "Login"
      fill_in 'email', with: @merchant.email
      fill_in 'password', with: @merchant.password

      click_button "Log In"

      click_link "Dashboard"
      expect(current_path).to eq(dashboard_path)

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.email)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)

      within "#item-#{@itemA.id}" do
        expect(page).to have_content(@itemA.name)
        expect(page).to have_content(@itemA.inventory)
        expect(page).to have_content("Edit")
        expect(page).to have_content("Disable")
        expect(page).to_not have_content("Enable")
        expect(page).to have_content("Delete")
      end

      within "#item-#{@itemB.id}" do
        expect(page).to have_content(@itemB.name)
        expect(page).to have_content(@itemB.inventory)
        expect(page).to have_content("Edit")
        expect(page).to_not have_content("Disable")
        expect(page).to have_content("Enable")
        expect(page).to have_content("Delete")
      end

      within "#item-#{@itemC.id}" do
        expect(page).to have_content(@itemC.name)
        expect(page).to have_content(@itemC.inventory)
        expect(page).to have_content("Edit")
        expect(page).to have_content("Disable")
        expect(page).to_not have_content("Enable")
        expect(page).to have_content("Delete")
      end
    end

    it "can edit an item" do
      visit root_path

      click_link "Login"

      fill_in 'email', with: @merchant.email
      fill_in 'password', with: @merchant.password

      click_button "Log In"

      click_link "Dashboard"
      expect(current_path).to eq(dashboard_path)

      within "#item-#{@itemA.id}" do
        click_on "Edit"
      end
      expect(current_path).to eq("/items/#{@itemA.id}/edit")
      fill_in 'item[name]', with: "ItemAHHHH"
      click_on "Update Item"

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Item updated.")
      within "#item-#{@itemA.id}" do
        expect(page).to have_content("ItemAHHHH")
      end
    end

    it "can enable/disable items" do
      visit root_path

      click_link "Login"
      fill_in 'email', with: @merchant.email
      fill_in 'password', with: @merchant.password
      click_button "Log In"

      click_link "Dashboard"
      expect(current_path).to eq(dashboard_path)

      within "#item-#{@itemA.id}" do
        click_on "Disable"
      end

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Item has been disabled.")
      within "#item-#{@itemA.id}" do
        expect(page).to_not have_content("Disable")
        expect(page).to have_content("Enable")
      end

      within "#item-#{@itemA.id}" do
        click_on "Enable"
      end

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Item has been enabled.")
      within "#item-#{@itemA.id}" do
        expect(page).to_not have_content("Enable")
        expect(page).to have_content("Disable")
      end
    end

    it "can edit an item" do
      visit root_path

      click_link "Login"
      fill_in 'email', with: @merchant.email
      fill_in 'password', with: @merchant.password
      click_button "Log In"

      click_link "Dashboard"
      expect(current_path).to eq(dashboard_path)

      within "#item-#{@itemA.id}" do
        click_on "Delete"
      end

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content("Item has been deleted.")
      expect(page).to_not have_content(@itemA.name)
    end

    it "displays a list of pending orders that contain merchant items" do
      visit root_path
      click_link "Login"
      fill_in 'email', with: @merchant_1.email
      fill_in 'password', with: @merchant_1.password
      click_button "Log In"
      expect(page).to have_content(@order_1.id)
      #the ID of the order, which is a link to the order show page ("/dashboard/orders/15")
      # expect(page).to have_link(@order_1.id) # might need to hard code this link in here, might be @order_1 without id
      expect(page).to have_content(@order_1.created_at.to_formatted_s(:long).slice(0...-6))
      expect(page).to have_content(@order_1.total_item_count)
      expect(page).to have_content('%.2f' % @order_1.total_price)
      expect(page).to have_content(@order_2.id)
      expect(page).to have_content(@order_2.created_at.to_formatted_s(:long).slice(0...-6))
      expect(page).to have_content(@order_2.total_item_count)
      expect(page).to have_content('%.2f' % @order_2.total_price)
    end

    describe "merchant statistics" do
      before :each do
        @merchant_3 = create(:merchant)
        @user_2 = create(:user)
        @user_3 = create(:user)
        @user_4 = create(:user)
        @user_5 = create(:user)

        @item_5 = create(:item, inventory: 15, user: @merchant_3)
        @item_6 = create(:item, inventory: 20, user: @merchant_3)
        @item_7 = create(:item, inventory: 25, user: @merchant_3)
        @item_8 = create(:item, inventory: 10, user: @merchant_3)
        @item_9 = create(:item, inventory: 5, user: @merchant_3)

        @order_5 = create(:shipped, user: @user_1)
        @order_6 = create(:shipped, user: @user_2)
        @order_7 = create(:shipped, user: @user_3)
        @order_8 = create(:shipped, user: @user_4)
        @order_9 = create(:shipped, user: @user_5)

        @order_item_8 = create(:order_item, item: @item_5, order: @order_5, quantity: 3)
        @order_item_9 = create(:order_item, item: @item_6, order: @order_5, quantity: 4)
        @order_item_10 = create(:order_item, item: @item_7, order: @order_6, quantity: 5)
        @order_item_11 = create(:order_item, item: @item_8, order: @order_7, quantity: 2)
        @order_item_12 = create(:order_item, item: @item_9, order: @order_8, quantity: 1)

        visit root_path
        click_link "Login"
        fill_in 'email', with: @merchant_3.email
        fill_in 'password', with: @merchant_3.password
        click_button "Log In"
        click_link "Dashboard"
      end

      it 'i see stats with the top 5 items I have sold by quantity' do
        within "#merchant-stats" do
          within "#top-5-items-sold" do
            expect(@item_7.name).to appear_before(@item_6.name)
            expect(@item_6.name).to appear_before(@item_5.name)
            expect(@item_5.name).to appear_before(@item_8.name)
            expect(@item_8.name).to appear_before(@item_9.name)
            expect(page).to have_content(5)
            expect(page).to have_content(4)
            expect(page).to have_content(3)
            expect(page).to have_content(2)
            expect(page).to have_content(1)
          end
        end
      end
      # - total quantity of items I've sold, and as a percentage against my sold units plus remaining inventory (eg, if I have sold 1,000 things and still have 9,000 things in inventory, the message would say something like "Sold 1,000 items, which is 10% of your total inventory")

      # it 'i see stats with the total quantity of all items sold' do
      #   within "#merchant-stats" do
      #     within "#total-quantity-items-sold" do
      #       expect(page).to have_content("Sold 15 items, which is 20% of your total inventory")
      #     end
      #   end
      # end
      # - top 3 states where my items were shipped, and their quantities
      # - top 3 city/state where my items were shipped, and their quantities (Springfield, MI should not be grouped with Springfield, CO)
      # - name of the user with the most orders from me (pick one if there's a tie), and number of orders
      # - name of the user who bought the most total items from me (pick one if there's a tie), and the total quantity
      # - top 3 users who have spent the most money on my items, and the total amount they've spent
    end
  end
end
