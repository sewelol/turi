require 'rails_helper'

RSpec.describe TripPublicController, type: :controller do
    before do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        sign_in(@user)
        @trip = FactoryGirl.create(:trip, :user => @user, :public => true)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)

    end

    describe "Get #show" do
        it "render the #show for participant" do
            get :show, id: @trip.id
            expect(response).to render_template :show
        end

        it "render the #show for none participant aslong as the trip is public" do
            get :show, id: @trip.id
            expect(response).to render_template :show
        end

        it "If the trip is not public the participant should still be able to see the public page" do
            trip_not_public = FactoryGirl.create(:trip, :user => @user)
            FactoryGirl.create(:participant, :trip_id => trip_not_public.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)

            get :show, id: trip_not_public.id
            expect(response).to render_template :show
        end

        it "if the trip is not public a none participant should not be able to see the public page" do
            trip_not_public = FactoryGirl.create(:trip, :user => @user2)
            get :show, id: trip_not_public.id
            expect(response).to_not render_template :show

            expect(response).to redirect_to dashboard_path
        end
    end
end
