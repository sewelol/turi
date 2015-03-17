require 'rails_helper'

RSpec.describe User do

  it "is valid with valid attributes" do
   expect(
     FactoryGirl.create(:user)
   ).to be_valid
  end

  it "is not valid without email" do
    expect{
      FactoryGirl.create(:user, email: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is not valid without name" do
    expect{
      FactoryGirl.create(:user, name: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is not valid without password" do
    expect{
      FactoryGirl.create(:user, password: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end