require 'rails_helper'

RSpec.feature 'Article Operations' do

  before do
    logout(:user)
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @part = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @owner.id)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @participant_part = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @part.id, participant_role_id: ParticipantRole.viewer.id)

  end

  scenario 'Editor can create article' do
    login_as(@editor, :scope => :user)
    @article = FactoryGirl.build(:article)
    visit trip_articles_path(@trip)

    click_link 'add_article_button'
    fill_in 'article_title', with: @article.title
    fill_in 'article_content', with: @article.content
    click_button 'article_create_button'

    expect(page).to have_content(I18n.t 'trip_article_created')
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.content)
  end

  scenario 'Editor can edit articles' do
    login_as(@editor, :scope => :user)
    @article = FactoryGirl.create(:article, trip_id: @trip.id)
    visit trip_article_path(@trip, @article)

    click_link 'edit_article_button'
    fill_in 'article_title', with: 'Various updates'
    fill_in 'article_content', with: 'Various content'
    click_button 'article_create_button'

    expect(page).to have_content('Various updates')
    expect(page).to have_content('Various content')
  end

  scenario 'Participants can view articles' do
    @article = FactoryGirl.create(:article, trip_id: @trip.id)
    login_as(@part, :scope => :user)
    visit trip_articles_path(@trip)

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.content)
  end

end