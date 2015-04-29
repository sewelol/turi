require 'rails_helper'


RSpec.feature "Route model test" do
  describe "route" do

    it "is invalid without a title" do
      expect {
        FactoryGirl.create(:route, :title => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid without a description" do
      expect {
        FactoryGirl.create(:route, :desc => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

