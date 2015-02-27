require 'rails_helper'

RSpec.feature 'Search Trips' do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @trip2nd = FactoryGirl.create(:trip, title: 'Another trip', start_date: '12/05/15', end_date: '27/05/15')

    @atag = 'fun, cold'
    @trip.tag_list = @atag
    @trip.save
    @trip2nd.tag_list = @atag
    @trip2nd.save
    visit root_path

    click_link 'Sign In'
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password

    click_button 'sign_in_button'
    click_link 'Search'
  end

  scenario 'do a search on location' do
    fill_in 'location_search', with: @trip.start_loc

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a search on tag' do
    fill_in 'tag_search', with: @atag

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a full search' do
    fill_in 'title_search', with: @trip2nd.title
    fill_in 'date_beg', with: @trip2nd.start_date
    fill_in 'date_end', with: @trip2nd.end_date
    fill_in 'tag_search', with: 'fun'

    click_button 'Search Trips'

    expect(page).to have_content(@trip2nd.title)
    expect(page).to_not have_content(@trip.title)
  end

  scenario 'do an unsuccessful search' do
    fill_in 'location_search', with: 'mars'

    click_button 'Search Trips'

    expect(page).to have_content('No trips matched your search parameters.')
  end

end