require 'rails_helper'

RSpec.describe Request, type: :model do

  it 'is not valid without user id' do
    expect {
      FactoryGirl.create(:request, user_id: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is not valid without requester id' do
    expect {
      FactoryGirl.create(:request, receiver_id: nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is valid with user id and requester id' do
    expect(
        FactoryGirl.create(:request)
    ).to be_valid
  end

  it 'is not valid to have same user and receiver id' do
    expect {
      FactoryGirl.create(:request, user_id: 1, receiver_id: 1)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'can not create a double request' do
    requestOne = FactoryGirl.create(:request)
    expect{
        FactoryGirl.create(:request,
                           user_id: requestOne.user_id,
                           receiver_id: requestOne.receiver_id)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'can not create a request to someone who request to be friend already' do
    requestOne = FactoryGirl.create(:request)
    expect{
      FactoryGirl.create(:request,
                         user_id: requestOne.receiver_id,
                         receiver_id: requestOne.user_id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
