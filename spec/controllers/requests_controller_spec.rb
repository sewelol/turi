require 'rails_helper'

RSpec.describe RequestsController, type: :controller do

  before do
    @user_one = FactoryGirl.create(:user)
    @user_two = FactoryGirl.create(:user)

    sign_in(@user_one)
  end

  describe "POST #create" do
    context 'with valid attributes' do
      it "creates a friend request" do
        expect {
          post :create, user_id: @user_one.id, receiver_id: @user_two.id
        }.to change(Request, :count).by(1)
      end

      it "renders the friends user page with notice" do
        post :create, user_id: @user_one.id, receiver_id: @user_two.id
        expect(response).to redirect_to user_path(@user_two)
      end
    end

    context "with invalid attributes" do
      it 'does not create a friend request to yourself' do
        expect {
          post :create, user_id: @user_one.id, receiver_id: @user_one.id
        }.to_not change(Request, :count)
      end

      it 'does not create a friend request to someone who doesnt exist' do
        expect {
          post :create, user_id: @user_one.id, receiver_id: 3837
        }.to_not change(Request, :count)
      end

      it 'does not render a user page that doesnt exist' do
        post :create, user_id: @user_one.id, receiver_id: 3837
        expect(response).to redirect_to user_path @user_one
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @friendRequest = Request.create(user_id: @user_one.id, receiver_id: @user_two.id)
      #puts @friendRequest.inspect
    end
    context 'with valid attributes' do
      it 'the requesting user destroys the request' do
        expect {
          delete :destroy, user_id: @user_one, id: @friendRequest
        }.to change(Request, :count).by(-1)
      end

      it 'the requested user destroys the request' do
        sign_out(@user_one)
        sign_in(@user_two)
        expect {
          delete :destroy, user_id: @user_two, id: @friendRequest
        }.to change(Request, :count).by(-1)
      end

      it 'the requesting user renders your user page' do
        delete :destroy, user_id: @user_one, id: @friendRequest
        expect(response).to redirect_to user_path @user_one
      end

      it 'the requested user renders the requesting user page' do
        sign_out @user_one
        sign_in @user_two
        delete :destroy, user_id: @user_two, id: @friendRequest
        expect(response).to redirect_to user_path @user_two
      end
    end

    context 'with invalid attributes' do
      it 'doesnt destroy a request' do
        expect {
          delete :destroy, user_id: @user_one, id: 231
        }.to_not change(Request, :count)
      end

      it 'renders the user page' do
        delete :destroy, user_id: @user_one, id: 1231
        expect(response).to redirect_to user_path @user_one
      end

    end

  end
end
