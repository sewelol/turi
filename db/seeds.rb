# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

account = Account.create(username: "user1",
	email: "user1@example.com",
	password: "password",
	password_confirmation: "password")

Trip.create(account: account,
			title: "Tromsø",
			description: "Fin tur",
			start_loc: "Tromsø",
			end_loc: "Oslo",
			#created_at: DateTime.civil_from_format(:local, 2015, month=2, day=16),
			#updated_at: DateTime.civil_from_format(:local, 2015, month=3, day=16),
			start_date: "01.01.2015",
			end_date: "05.01.2015",
			)