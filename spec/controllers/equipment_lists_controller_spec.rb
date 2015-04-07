require 'rails_helper'

RSpec.describe EquipmentListsController, type: :controller do
    before do
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip)
        FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @user.id, participant_role_id: ParticipantRole.owner.id)
        sign_in(@user)
        # set HTTP_REFERER to root_path, to make :back redirects to work
        request.env['HTTP_REFERER'] = root_path
        
    end

    describe "GET #index" do
        it "render the template" do
            get :index, :trip_id => @trip.id
            expect(response).to render_template :index
        end
    end

    describe "GET #new" do
        it "render the template" do
            get :new, trip_id: @trip.id
            expect(response).to render_template :new
        end
    end

    describe "POST #create" do
        it "Create a valid Equipment list" do
            expect { post :create, :trip_id => @trip.id, :equipment_list => FactoryGirl.attributes_for(:equipment_list, :trip_id => @trip.id) }.to change(EquipmentList, :count).by(1)
            #expect(response).to redirect_to EquipmentList(@trip).last  # FIXME i have no clue what to put here
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_created')
        end

        it "Create a valid Equipment list, for a non existing trip" do
            post :create, :trip_id => 999, :equipment_list => FactoryGirl.attributes_for(:equipment_list, :trip_id => 999)
            expect(flash[:alert]).to eq(I18n.t 'trip_not_found')
            expect(response).to redirect_to root_path
        end

        it "Render the form again, if something went wrong" do
            post :create, :trip_id => @trip.id, equipment_list: FactoryGirl.attributes_for(:equipment_list, :name => nil)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_not_created')
            expect(response).to render_template :new
        end
    end

    describe "GET #show" do
        it "Render and assign the #show" do
            equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
            get :show, :trip_id => @trip.id, :id => equipment_list.id
            expect(assigns(:equipment_list)).to eq(equipment_list)
            expect(response).to render_template :show
        end

        it "Get a unvalid equipment list" do
            get :show, :trip_id => @trip.id, :id => 999
            expect(response).to redirect_to root_path
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_not_found')
        end
    end

    describe "PUT #edit" do
        before do
            @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        end

        it "locate the requested and redirect to the @equipment_list" do
            put :update, :trip_id => @trip.id, :id => @equipment_list.id, :equipment_list => FactoryGirl.attributes_for(:equipment_list)
            expect(assigns(:equipment_list)).to eq(@equipment_list)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_updated')
        end

        it "change the @equipment_list's attributes" do
            put :update, :trip_id => @trip.id, :id => @equipment_list.id, :equipment_list => FactoryGirl.attributes_for(:equipment_list, :name => "Something else", :description => "Something")
            @equipment_list.reload
            expect(@equipment_list.name).to eq("Something else")
            expect(@equipment_list.description).to eq("Something")
        end

        it "invalid/missing attributes" do
            put :update, :trip_id => @trip.id, :id => @equipment_list.id, :equipment_list => FactoryGirl.attributes_for(:equipment_list, :name => nil, :description => "Something")
            @equipment_list.reload
            expect(@equipment_list.description).not_to eq("Something")
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_not_updated')
        end
            
    end

    describe "DELETE #delete" do
        before do
            @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        end

        it "Deletes the equipment_list" do
            expect { delete :destroy, :trip_id => @trip.id, :id => @equipment_list.id}.to change(EquipmentList, :count).by(-1)
            expect(response).to redirect_to trip_path(@trip.id)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_deleted')
        end
    end
end
