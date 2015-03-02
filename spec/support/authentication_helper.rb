module AuthenticationHelpers
  def sign_in_as!(user)
    visit '/'
    click_link "Sign In"
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "sign_in_button"
    #expect(page).to have_content("Signed in successfully.")
  end
end


RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :feature
end