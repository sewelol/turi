require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'event' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:event)).to be_valid
    end

    it 'is invalid without a name' do
      expect {
        FactoryGirl.create(:event, :name => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is invalid without a start_date' do
      expect {
        FactoryGirl.create(:event, :start_date => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is invalid without a end_date' do
      expect {
        FactoryGirl.create(:event, :end_date => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is invalid without a color' do
      expect {
        FactoryGirl.create(:event, :color => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is invalid without a end_date before the start_date' do
      start_date = DateTime.now + 3.hours
      end_date = DateTime.now
      expect {
        FactoryGirl.create(:event, :start_date => start_date, :end_date => end_date)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
