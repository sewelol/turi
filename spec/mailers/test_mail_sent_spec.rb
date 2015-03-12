require 'rails_helper'

RSpec.feature "Check that the mail is not sent to the WWW" do
  let!(:user) { FactoryGirl.create(:user)}

  before do
    visit new_user_password_path
  end

  it "sends email to ActionMailer::Base.deliveries" do
    expect {
      fill_in "user_email", with: user.email
      click_button "Remind Password"
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end