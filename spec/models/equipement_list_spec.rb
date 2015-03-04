require 'rails_helper'


RSpec.feature "equipment_list model test" do
    describe "equipment_list" do
        it "has a valid factory" do
            expect(FactoryGirl.create(:equipment_list)).to be_valid
        end

        it "is invalid without a name" do
            expect {
                FactoryGirl.create(:equipment_list, :name => nil)
            }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it "is invalid without a description" do
            expect {
                FactoryGirl.create(:equipment_list, :description => nil)
            }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end
end

