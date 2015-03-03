require 'rails_helper'

=begin
Use let to define a memorized helper method. The value will be cached
across multiple calls in the same example but not across examples.

Note that let is lazy-evaluated: it is not evaluated until the first time
the method it defines is invoked. You can use let! to force the method's
invocation before each example.
=end

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    #session[:user_id] = user.id
    sign_in(user)
  end

  context "get #show" do
    it "directs to user page when user id exist" do
      get :show, id: user.id

      expect(response).to render_template(:show)
    end

    it " directs to root page when user id doesn't exist" do
      get :show, id: 202

      expect(response).to redirect_to(dashboard_path)
      expect(flash[:alert]).to have_content(I18n.t('user_id_not_found'))
    end
  end

  context "PUT #edit" do
    it "sends us to edit" do
      get :edit, id: user.id

      expect(response).to render_template(:edit)
    end
  end

  context "put #edit" do
    before do


    end
    it "saves the user" do
      put :update, id: user.id
      expect(response).to render_template(:edit)
    end
  end
end
