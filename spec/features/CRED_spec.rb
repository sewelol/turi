require 'rails_helper'

RSpec.feature 'CRED operations for Trips' do
    before do
        @trip = FactoryGirl.build(:trip)
        @user = FactoryGirl.create(:user)

        
        login_as(@user, :scope => :user)
        visit dashboard_path
    end

    scenario 'Create/Show Trip' do
        click_link 'create_trip'
        fill_in 'Title', with: @trip.title
        fill_in 'Description', with: @trip.description
        fill_in 'trip_start_loc', with: @trip.start_loc
        fill_in 'trip_end_loc', with: @trip.end_loc
        fill_in 'trip_image', with: @trip.image
        @tags = 'awesome, cool, pretty'
        fill_in 'trip_tag_list', with: @tags
        click_button 'Create Trip'


        
        expect(page).to have_content(I18n.t 'trip_created')

        expect(page).to have_content(@trip.title)
        expect(page).to have_content(@trip.description)
        expect(page).to have_content(@trip.start_loc)
        expect(page).to have_content(@trip.end_loc)

        within '.trip .owner' do
            expect(page).to have_content('Created by ' << @user.name)
        end
    end
    

# FIXME It seems like rspec can't click links in the sidebar. 
#    scenario 'Edit Trip' do
#        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
#        
#        visit trip_path(@trip)
#        click_link 'edit_trip'
#        expect(page.current_path).to eq(edit_trip_path(@trip)(
#
#        fill_in 'Title', with: 'Not The Trip Title'
#        fill_in 'Description', with: 'Not the Trip Description'
#        click_button 'submit'

#        expect(page).to have_content(I18n.t('trip_updated'))
#        expect(page).to_not have_content(@trip.title)
#        expect(page).to_not have_content(@trip.description)
#    end

#    scenario 'Delete Trip' do
#        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
#        visit trip_path(@trip)

#        click_link 'delete_trip_button'
#        expect(page).to have_content(I18n.t('trip_deleted'))
#    end

#    scenario 'Cancel Update' do
#        @trip = FactoryGirl.create(:trip, :user_id => @user.id)
#        visit trip_path(@trip)

#        click_link 'edit_trip'
#        fill_in 'Title', with: 'Editing Title'
#        click_link 'cancel_button'

#        expect(page).to have_content(@trip.title)
#    end

    scenario 'Redirection if trying to enter not made trip' do
        visit '/trips/99'
        expect(page.current_path).to eq(dashboard_path)
        expect(page).to have_content(I18n.t ('trip_not_found'))
    end
end

