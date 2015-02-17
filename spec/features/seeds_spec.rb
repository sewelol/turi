require 'rails_helper'

feature "Seed Data" do
	scenario "The basics" do
		load Rails.root + "db/seeds.rb"
		Account = Account.where(email: "user1@example.com").first!
		Trip = Trip.where(account: Account,
			title: "Tromsø",
			description: "Fin tur",
			start_loc: "Tromsø",
			end_loc: "Oslo",
			#created_at: DateTime.civil_from_format(:local, 2015, month=2, day=16),
			#updated_at: DateTime.civil_from_format(:local, 2015, month=3, day=16),
			start_date: "01.01.2015",
			end_date: "05.01.2015").first!
	end
end