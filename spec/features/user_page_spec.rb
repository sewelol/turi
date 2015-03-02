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
    visit "/users/#{user.id}"
  end

  scenario "see user details" do
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
  end

  scenario "edit user details with correct details" do
    click_link "Edit"
    expect(page).to have_content("Welcome to the edit user page")
    #expect(response).to render_template(:edit)

    runar = User.create(name: "Runar", email: "runar@turi.no", age: 24, country: "Japan", town: "Japan", status: "It's complicated")

    fill_in 'Name', with: runar.name
    fill_in 'Email', with: runar.email
    fill_in 'Age', with: runar.age
    fill_in 'Country', with: runar.country
    fill_in 'Town', with: runar.town
    fill_in 'Status', with: runar.status

    click_button "Update User"

    expect(page).to have_content(runar.email)
    expect(page).to have_content(runar.name)
    expect(page).to have_content(runar.age)
    expect(page).to have_content(runar.country)
    expect(page).to have_content(runar.town)
    expect(page).to have_content(runar.status)
  end

  scenario "edit user details with incorrect details" do
    fill_in 'email', with: ""
    click_button "Update User"

    #expect(page).to have_content(118.t('errors.message.too_short, attribute: User.human_attribute_name('email'), count:5))
  end
end