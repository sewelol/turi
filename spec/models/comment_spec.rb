require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is valid with valid attributes' do
    expect(
        FactoryGirl.create(:comment)
    ).to be_valid
  end

  it 'is not valid without body' do
    expect{
      FactoryGirl.create(:comment, body: '')
    }.to raise_error ActiveRecord::RecordInvalid
  end
end
