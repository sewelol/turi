require 'rails_helper'

describe ApiAccessTokenPolicy do

  subject { described_class }

  before do
    @owner = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @access_token = FactoryGirl.create(:api_access_token, trip_id: @trip.id, user_id: @owner.id, api_provider_id: ApiProvider.dropbox.id)
  end

  permissions :destroy? do

    it 'denies destroying token for stranger' do
      expect(subject).not_to permit(@stranger, @access_token)
    end

    it 'allows destroying token for token owner' do
      expect(subject).to permit(@owner, @access_token)
    end

  end

end