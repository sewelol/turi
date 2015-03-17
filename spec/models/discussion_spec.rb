require 'rails_helper'

RSpec.describe Discussion, type: :model do
  it 'is valid with valid attributes' do
    expect{
      FactoryGirl.create(:discussion)
    }.to be_valid
  end

  it 'is not valid without title' do
    expect{
      FactoryGirl.create(:discussion, title: "")
    }.to raise_error ActiveRecord::RecordInvalid
  end
end
