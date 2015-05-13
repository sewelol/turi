require 'rails_helper'


RSpec.feature "equipment_list model test" do
    before do
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, :user => @user)
    end

    describe "equipment_list" do
        it "has a valid factory" do
            expect(FactoryGirl.create(:equipment_list, :user => @user, :trip => @trip )).to be_valid
        end

        it "is invalid without a name" do
            expect {
                FactoryGirl.create(:equipment_list,:user => @user, :trip => @trip, :name => nil)
            }.to raise_error(ActiveRecord::RecordInvalid)
        end

    end
end

