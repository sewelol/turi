require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  before do
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @viewer = FactoryGirl.create(:user)
    @trip_one = FactoryGirl.create(:trip)
    @trip_two = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip_one.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip_one.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @participant_viewer = FactoryGirl.create(:participant, trip_id: @trip_one.id, user_id: @viewer.id, participant_role_id: ParticipantRole.viewer.id)
    sign_in(@owner)
  end

  describe 'GET #index' do
    it 'should render index with associated articles' do
      FactoryGirl.create(:article, trip_id: @trip_one.id)
      FactoryGirl.create(:article, trip_id: @trip_one.id)
      FactoryGirl.create(:article, trip_id: @trip_one.id)
      blog_other = FactoryGirl.create(:article, trip_id: @trip_two.id)
      get :index, trip_id: @trip_one.id

      expect(assigns(:articles).count).to eq(3)
      expect(assigns(:articles)).not_to include(blog_other)
      expect(response).to have_rendered(:index)
    end
  end

  describe 'GET #show' do
    it 'should render show' do
      blog = FactoryGirl.create(:article, trip_id: @trip_one.id)
      get :show, trip_id: @trip_one.id, id: blog.id

      expect(response).to have_rendered(:show)
    end
  end

  describe 'GET #new' do
    it 'should render new' do
      get :new, trip_id: @trip_one.id

      expect(response).to have_rendered(:new)
    end
  end

  describe 'GET #edit' do
    it 'should render edit' do
      blog = FactoryGirl.create(:article, trip_id: @trip_one.id)
      get :edit, trip_id: @trip_one.id, id: blog.id

      expect(assigns(:article)).to eq(blog)
      expect(response).to have_rendered(:edit)
    end
  end

  describe 'POST #create' do
    it 'should create an article and redirect to the article view' do
      expect {post :create, trip_id: @trip_one.id, :article => FactoryGirl.attributes_for(:article, trip_id: @trip_one.id) }.to change(Article, :count).by(1)
      expect(flash[:notice]).to eq(I18n.t 'trip_article_created')
    end

    it 'should render new again on error' do
      post :create, trip_id: @trip_one.id, :article => FactoryGirl.attributes_for(:article, title: nil)

      expect(flash[:alert]).to eq(I18n.t 'trip_article_not_created')
      expect(response).to have_rendered(:new)
    end
  end

  describe 'PUT #edit' do
    before do
      @art = FactoryGirl.create(:article, trip_id: @trip_one.id)
    end

    it 'should redirect to @article' do
      put :update, trip_id: @trip_one.id, id: @art.id, :article => FactoryGirl.attributes_for(:article)
      expect(assigns(:article)).to eq(@art)
      expect(flash[:notice]).to eq(I18n.t 'trip_article_updated')
    end

    it 'should update article with valid parameters' do
      put :update, trip_id: @trip_one.id, id: @art.id, :article => FactoryGirl.attributes_for(:article, title: 'A new title', content: 'Lorem Ipsum')
      @art.reload
      expect(@art.title).to eq('A new title')
      expect(@art.content).to eq('Lorem Ipsum')
    end

    it 'should not update with invalid parameters' do
      put :update, trip_id: @trip_one.id, id: @art.id, :article => FactoryGirl.attributes_for(:article, title: '', content: '')
      expect(assigns(:article)).to eq(@art)
      expect(flash[:alert]).to eq(I18n.t 'trip_article_not_updated')
    end
  end

  describe 'DELETE #destroy' do
    before do
      @art = FactoryGirl.create(:article, trip_id: @trip_one.id)
    end

    it 'should delete the entry' do
      expect { delete :destroy, trip_id: @trip_one.id, id: @art.id}.to change(Article, :count).by(-1)
      expect(response).to redirect_to trip_articles_path(@trip_one)
      expect(flash[:notice]).to eq(I18n.t 'trip_article_destroyed')
    end
  end
end
