require 'rails_helper'

RSpec.feature 'CRED operations for Trips' do
    before do
        @trip = FactoryGirl.create(:trip)
        @user = FactoryGirl.create(:user)
        
        visit root_path
        click_link 'Sign In'

        sign_in
        click_link 'create_trip_link'

        fill_in 'Title', with: @trip.title
        fill_in 'Description', with: @trip.description
        fill_in 'Start loc', with: @trip.start_loc
        fill_in 'End loc', with: @trip.end_loc
        fill_in 'Image', with: @trip.image
        @tags = 'awesome, cool, pretty'
        fill_in 'Tag list', with: @tags
        click_button 'Create Trip'
    end

    scenario 'Create/Show Trip' do
        #FIXME: Expect for 'url_for' is not working as expected
        #expect(page.current_path).to eq(url_for(@trip))
        expect(page).to have_content(@trip.title)
        expect(page).to have_content(@trip.description)
        expect(page).to have_content(@trip.start_loc)
        expect(page).to have_content(@trip.end_loc)

        within '.trip .owner' do
            expect(page).to have_content('Created by ' << @user.name)
        end
        # image?
    end
    
    scenario 'Edit Trip' do
        click_link 'Edit'
        fill_in 'Title', with: 'Not The Trip Title'
        fill_in 'Description', with: 'Not the Trip Description'
        click_button 'Update Trip'

        expect(page).to have_content('Trip has been updated')
        expect(page).to_not have_content(@trip.title)
        expect(page).to_not have_content(@trip.description)
    end

    scenario 'Delete Trip' do
        click_link 'Delete'
        expect(page).to have_content('Trip has been deleted')
        expect(page).to_not have_content(@tags.delete!',')
    end

    scenario 'Cancel Update' do
        click_link 'Edit'
        fill_in 'Title', with: 'Editing Title'
        click_button 'cancel_button'
        expect(page.current_path).to eq edit_trip_path(@trip.id + 1)
        #expect(page).to have_content('Trip was not updated.')
        expect(page).to have_content(@trip.title)
    end

    scenario 'Cancel Creation' do
        click_link 'create_trip_link'
        fill_in 'Title', with: 'Cancel Trip'
        fill_in 'Tag list', with: 'sjokoloade'
        click_button 'cancel_button'
        #expect(page).to have_content('Trip creation cancelled.')
        expect(page).to_not have_content('sjokoloade')
    end

    scenario 'Redirection if trying to enter not made trip' do
        visit '/trips/99'
        expect(page).to have_content('The trip was not found!')
    end

    def sign_in
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      click_button 'sign_in_button'
    end


end

