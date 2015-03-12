require 'rails_helper'

RSpec.feature "I forgot the password" do
  let!(:forgetful_user) { FactoryGirl.create(:user, email: "iforget@forget.com") }

  before do
    ActionMailer::Base.deliveries.clear
    visit '/'

    click_link 'Sign In'
    click_link 'forgot_password'
    fill_in "user_email", with: 'iforget@forget.com'
    click_button "Remind Password"

    @email = find_email!(forgetful_user.email)
  end

  scenario "renders the subject" do
    subject = I18n.t('devise.mailer.reset_password_instructions')
    expect(@email.subject).to have_content subject[":subject"]
  end

  scenario "renders the receiver email" do
    expect(@email.to[0]).to eql(forgetful_user.email)
  end

  scenario "renders the receiver email" do
    expect(@email.from[0]).to eql("postmaster@turi.fsauter.de")
  end

  scenario "assigns @name" do
    expect(@email.body.encoded).to match(forgetful_user.email)
  end

  scenario "assigns edit_user_password_url" do
    expect(@email.body.encoded).to match(edit_user_password_path)
  end
end