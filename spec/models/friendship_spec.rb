require 'rails_helper'

RSpec.describe Friendship do
  it "has a valid factory" do
    expect(FactoryGirl.create(:friendship)).to be_valid
  end
end
