require 'rails_helper'

RSpec.feature 'Article Operations' do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)

    login_as(@user, :scope => :user)

    visit dashboard_path
    visit trip_articles_path
  end

  scenario 'Create Article' do

  end

  scenario 'Edit Article' do

  end

  scenario 'Delete Article' do

  end
end