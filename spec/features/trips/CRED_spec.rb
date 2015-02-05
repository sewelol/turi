require 'rails_helper'

RSpec.feature "CRED operations for Trips" do
    before do
        @trip = FactoryGirl.create(:trip)
        
        visit '/'                           # PlaceHolder
        click_link "Create Trip"            # ----"-----
        expect(page).to have_content("Create Trip")

        fill_in "Title", with: @trip.title
        fill_in "Description", with: @trip.description
        fill_in "Start loc", with: @trip.start_loc
        fill_in "End loc", with: @trip.end_loc
        fill_in "Image", with: @trip.image
        # more?
        click_button "Create Trip"
    end

    scenario "Create/Show Trip" do
        expect(page).to have_content("You successfully created a trip")
        expect(page).to have_content(@trip.title)
        expect(page).to have_content(@trip.description)
        expect(page).to have_content(@trip.start_loc)
        expect(page).to have_content(@trip.end_loc)
        # image?
    end
    
    scenario "Edit Trip" do
        click_link "Edit"
        fill_in "Title", with: "Not The Trip Title"
        fill_in "Description", with: "Not the Trip Description"
        click_button "Update Trip"

        expect(page).to have_content("Trip has been updated")
        expect(page).to_not have_content(@trip.title)
        expect(page).to_not have_content(@trip.description)
    end

    scenario "Delete Trip" do
        click_link "Delete"
        expect(page).to have_content("Trip has been deleted")
    end

    scenario "Redirection if trying to enter not made trip" do
        visit '/trips/99'
        expect(page).to have_content("The trip was not found!")
    end

end

