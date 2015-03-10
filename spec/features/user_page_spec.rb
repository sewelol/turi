require 'rails_helper'

=begin
Use let to define a memoized helper method. The value will be cached
across multiple calls in the same example but not across examples.

Note that let is lazy-evaluated: it is not evaluated until the first time
the method it defines is invoked. You can use let! to force the method's
invocation before each example.
=end

feature 'User_page' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_as!(user)
    visit user_path(user)
  end

  scenario 'see user details' do
    #TODO email
    expect(page).to have_content(user.email)
    #TODO name
    expect(page).to have_content(user.name)
    #TODO country and town
    expect(page).to have_content(user.country)
    expect(page).to have_content(user.town)
    #TODO age
    expect(page).to have_content(user.age)
    #TODO status
    expect(page).to have_content(user.status)
    #TODO picture
    # http://tinypic.com/r/2rqyvc9/8

  end

  scenario 'edit user details with correct details' do
    click_link 'Edit'
    expect(page).to have_content('Welcome to the edit user page')
    #expect(response).to render_template(:edit)

    runar = User.create(name: 'Runar', email: 'runar@turi.no', age: 24, country: 'Japan', town: 'Japan', status: 'It\'s complicated')

    fill_in 'Name', with: runar.name
    fill_in 'Email', with: runar.email
    fill_in 'Age', with: runar.age
    fill_in 'Country', with: runar.country
    fill_in 'Town', with: runar.town
    fill_in 'Status', with: runar.status

    click_button 'Update User'

    expect(page).to have_content(runar.email)
    expect(page).to have_content(runar.name)
    expect(page).to have_content(runar.age)
    expect(page).to have_content(runar.country)
    expect(page).to have_content(runar.town)
    expect(page).to have_content(runar.status)
  end

  scenario 'edit user details with incorrect details' do
    click_link 'Edit'
    fill_in 'Email', with: ''
    fill_in 'Name', with: ''
    click_button 'Update User'

    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Name can\'t be blank')
  end

  scenario 'edit user email with taken email' do
    taken_user = FactoryGirl.create(:user, email: 'ingvild92@yahoo.com')
    click_link 'Edit'
    fill_in 'Email', with: taken_user.email
    click_button 'Update User'

    expect(page).to have_content('Email has already been taken')
  end

  scenario "can't edit other peoples user pages" do
    other_user = FactoryGirl.create(:user)
    visit "/users/#{other_user.id}"

    expect(page).to_not have_selector(:link_or_button, "Edit")
  end
end
