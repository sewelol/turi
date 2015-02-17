require 'rails_helper'

feature "Dashboard data" do
	before do
		@account = FactoryGirl.create(:account)
		@account2 = FactoryGirl.create(:account, 
			username: "Ingvild",
			email: "ingvild@uit.no")
		@trip = FactoryGirl.create(:trip,
			account: @account)
		@trip2 = FactoryGirl.create(:trip, title: "New Trip", account: @account2)
		visit "/"
		click_link "Sign In"
		fill_in "sign_in_username", with: @account.username
		fill_in "sign_in_password", with: @account.password
		click_button "Sign In"
	end

	scenario "user dashboard" do
		within(".my-trips") do
			expect(page).to have_content(@trip.title)
			expect(page).to_not have_content(@trip2.title)
		end

		within(".all-trips") do
			expect(page).to have_content(@trip.title)
			expect(page).to have_content(@trip2.title)
		end

		within(".tags") do
			#need implementation
		end
	end
end

