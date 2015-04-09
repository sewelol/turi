require 'rails_helper'

RSpec.describe EquipmentAssignmentsController, type: :controller do
    before do
        @owner = FactoryGirl.create(:user)
        @editor = FactoryGirl.create(:user)
        @viwer = FactoryGirl.create(:user)
        @stranger = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @owner.id, :participant_role_id => ParticipantRole.owner.id)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @editor.id, :participant_role_id => ParticipantRole.editor.id)


        @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @owner)
        @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @owner.id)


        # set http_referer so redirect_to :back will be to the root_path
        request.env["HTTP_REFERER"] = root_path
        sign_in(@owner)            
    end

    describe "POST #create" do
        before do
            @equipment_assignment = FactoryGirl.build(:equipment_assignment, :equipment_item_id => @equipment_item.id, :number => 2)
        end

        it "Create a valid equipment_assignment for the owner as the owner" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id, :number => 2)
            }.to change(EquipmentAssignment, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_created')
        end


        it "Create a valid equipment_assignment with the editors email" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @editor.id)
            }.to change(EquipmentAssignment, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_created')
        end

        it "Assigments should 'stack' when user_id matches a already exisiting record" do
            FactoryGirl.create(:equipment_assignment, :equipment_item => @equipment_item, :user_id => @owner.id)
            expect {
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id)
            }.to change(EquipmentAssignment, :count).by(0)
            @ea = @equipment_item.equipment_assignments.find_by(:user_id => @owner.id)
            expect(@ea.number).to eq(@equipment_assignment.number * 2)
        end
    end


    describe "POST #delete" do
        before do 
            @equipment_assignment = FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @owner.id)
        end

        it "delete the equipment_assignment" do
            expect { 
                post :destroy, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id
            }.to change(EquipmentAssignment, :count).by(-1)
            expect(response).to redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_deleted')
        end
    end
end
