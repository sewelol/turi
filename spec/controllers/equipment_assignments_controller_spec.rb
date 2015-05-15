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
    end

        it "Controller does updates the record if the record with the same user_id exists in the database" do
            FactoryGirl.create(:equipment_assignment, :equipment_item => @equipment_item, :user_id => @owner.id)
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id, :number => 2)
            }.to change(EquipmentAssignment, :count).by(0)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_updated')
        end

        it "A value which is higher than the equipment_item's number is rejected" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id, :number => @equipment_item.number + 1)
            }.to change(EquipmentAssignment, :count).by(0)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_assignment_not_created')
        end

        it "A none existing record should not be made unless value is higher than 0" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id, :number => 0)
            }.to change(EquipmentAssignment, :count).by(0)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_assignment_not_created')
        end

        it "An existing record should be deleted when a updates is made with a number less than 1" do
            FactoryGirl.create(:equipment_assignment, :equipment_item => @equipment_item, :user_id => @owner.id)
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_id => @owner.id, :number => 0)
            }.to change(EquipmentAssignment, :count).by(-1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_deleted')


        end



    describe "POST #delete" do
        before do 
            @equipment_assignment = FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @owner.id)
        end

        it "delete the equipment_assignment" do
            expect { 
                post :destroy, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id
            }.to change(EquipmentAssignment, :count).by(-1)
            expect(response).to redirect_to trip_equipment_list_path(@trip, @equipment_list)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_deleted')
        end
    end
end
