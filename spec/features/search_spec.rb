require 'rails_helper'

RSpec.feature 'Search Trips' do
  before do
    @user = FactoryGirl.create(:user)
    @user2nd = FactoryGirl.create(:user, name: 'Ingvild')
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @trip2nd = FactoryGirl.create(:trip, title: 'Another trip', start_date: '12/05/15', end_date: '27/05/15', user_id: @user.id)

    @atag = 'fun, cold'
    @trip.tag_list = @atag
    @trip.save
    @trip2nd.tag_list = @atag
    @trip2nd.save

    login_as(@user, :scope => :user)

    visit dashboard_path
    click_link 'search_page_link'
  end

  scenario 'do a trip search' do
    fill_in 'title_search', with: @trip2nd.title
    fill_in 'date_beg', with: @trip2nd.start_date
    fill_in 'date_end', with: @trip2nd.end_date
    fill_in 'tag_search', with: 'fun'

    click_button 'search_trips_form_btn'

    expect(page).to have_content(@trip2nd.title)
    expect(page).to_not have_content(@trip.title)
  end

  scenario 'do a search on location' do
    fill_in 'location_search', with: @trip.start_loc

    click_button 'search_trips_form_btn'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a search on trip tag' do
    fill_in 'tag_search', with: @atag

    click_button 'search_trips_form_btn'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do an unsuccessful trip search' do
    fill_in 'location_search', with: 'mars'

    click_button 'search_trips_form_btn'

    expect(page).to have_content(I18n.t('search_no_trips'))
  end

  scenario 'do a user search' do
    click_link 'search_users_tab_link'

    fill_in 'name_search', with: @user.name

    click_button 'search_users_form_btn'

    expect(page).to have_content(@user.name)
    expect(page).to_not have_content(@user2nd.name)
  end

  scenario 'do an unsuccessful user search' do
    click_link 'search_users_tab_link'

    fill_in 'name_search', with: 'asjkdasljadsljdsaljaslfljaslashlasdkldasasdkadsöadsköasdklöasdöasödas'

    click_button 'search_users_form_btn'

    expect(page).to have_content(I18n.t('search_no_users'))
  end

end