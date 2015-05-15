require 'rails_helper'


# Model test for equipment_assignment #
# The model validates the presence of a number, user and equipment_item #

RSpec.describe EquipmentAssignment, type: :model do
    before do 
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip)
        @equipment_list = FactoryGirl.create(:equipment_list, :trip => @trip, :user => @user)
        @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
    end


    it "has a valid factory" do
        expect(FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @user.id)).to be_valid
    end

    it "is invalid without a number" do
        expect {
            FactoryGirl.create(:equipment_assignment, :number => nil, :equipment_item_id => @equipment_item.id, :user_id => @user.id) 
        }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid without a valid user " do
        expect {
            FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => nil) 
        }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid without a valid equipment_item " do
        expect {
            FactoryGirl.create(:equipment_assignment, :equipment_item_id => nil, :user_id => @user.id) 
        }.to raise_error(ActiveRecord::RecordInvalid)
    end
end
