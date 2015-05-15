require 'rails_helper'

RSpec.describe TripsController, :type => :controller do
    before do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        sign_in(@user)


        # Redirect_to :back fix
        request.env["HTTP_REFERER"] = root_path
    end


    describe "GET #index" do
    end

    describe "GET #new" do
        it "render the template" do
            get :new
            expect(response).to render_template :new
        end
    end


    describe "POST #create" do
        
        it "Create a valid trip" do
            expect { post :create, trip: FactoryGirl.attributes_for(:trip) }.to change(Trip, :count).by(1)
            expect(response).to redirect_to Trip.last
            expect(flash[:notice]).to eq(I18n.t 'trip_created')
        end


        it "Render the form again, if something went wrong" do
            post :create, trip: FactoryGirl.attributes_for(:trip, :title => nil)
            expect(flash[:alert]).to eq(I18n.t :form_invalid)
            expect(response).to render_template :new
        end
    end

    describe "GET #show" do
        it "Render and assign the the #show" do
            trip = FactoryGirl.create(:trip, :user_id => @user.id)
            FactoryGirl.create(:participant, :trip_id => trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)

            get :show, id: trip
            expect(assigns(:trip)).to eq(trip)            
            expect(response).to render_template :show
        end

        it "get a unvalid trip" do
            get :show, id: 999
            expect(response).to redirect_to root_path
            expect(flash[:alert]).to eq(I18n.t 'trip_not_found')
        end

        it "redirects to public view if user is not a participant and the trip is public" do
            trip = FactoryGirl.create(:trip, :user => @user2, :public => true)
            get :show, id: trip.id

            expect(response).to redirect_to trip_public_path(trip.id)
        end

    end


    describe "PUT #edit" do
        before do
            @trip = FactoryGirl.create(:trip)
            FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)
        end

        it "locate the requested and redirect to the @trip" do
            put :update, id: @trip, :trip => FactoryGirl.attributes_for(:trip)
            expect(assigns(:trip)).to eq(@trip)
            expect(response).to redirect_to @trip
            expect(flash[:notice]).to eq(I18n.t 'trip_updated')
        end

        it "change the @trip's attributes" do
            put :update, id: @trip, :trip => FactoryGirl.attributes_for(:trip, :title => "Edited Title", :description => "Edited Description")
            @trip.reload
            expect(@trip.title).to eq("Edited Title")
            expect(@trip.description).to eq("Edited Description")
        end

        it "Invalid attributes" do
            put :update, :id => @trip, :trip => FactoryGirl.attributes_for(:trip, :title => nil, :description => "Something")
            @trip.reload
            expect(@trip.description).not_to eq("Something")
            expect(@trip.title).to eq(@trip.title)
            expect(response).to render_template :edit
            expect(flash[:alert]).to eq(I18n.t :form_invalid)
        end
    end

    describe "DELETE #delete" do
        before do 
            @trip = FactoryGirl.create(:trip)
            @part = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
        end

        it "Deletes the trip" do
            expect { delete :destroy, id: @trip }.to change(Trip, :count).by(-1)
            expect(response).to redirect_to dashboard_path
            expect(flash[:notice]).to eq(I18n.t 'trip_deleted')
        end
    end
end
