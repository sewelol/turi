require 'rails_helper'

RSpec.feature 'Search Trips' do
  before do
    @user = FactoryGirl.create(:account)
    @trip = FactoryGirl.create(:trip)

    @atag = 'fun, cold'
    @trip.tag_list = @atag
    @trip.save
    visit '/'

    click_link 'Sign In'
    fill_in 'sign_in_username', with: @user.username
    fill_in 'sign_in_password', with: @user.password

    click_button 'Sign In'
    click_link 'Search'
  end

  scenario 'do a search on title' do
    fill_in 'title_search', with: @trip.title

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a search on tag' do
    fill_in 'tag_search', with: @atag

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do an unsuccessful search' do
    fill_in 'location_search', with: 'desert'

    click_button 'Search Trips'

    expect(page).to have_content('No trips matched your search parameters.')
  end

end