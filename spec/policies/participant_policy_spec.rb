require 'rails_helper'

describe ParticipantPolicy do

  subject { described_class }

  before do
    @owner = FactoryGirl.create(:user)
    @editor = FactoryGirl.create(:user)
    @viewer = FactoryGirl.create(:user)
    @stranger = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip)
    @participant_owner = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @owner.id, participant_role_id: ParticipantRole.owner.id)
    @participant_editor = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @editor.id, participant_role_id: ParticipantRole.editor.id)
    @participant_viewer = FactoryGirl.create(:participant, trip_id: @trip.id, user_id: @viewer.id, participant_role_id: ParticipantRole.viewer.id)
  end

  permissions :destroy? do

    it 'denies destroying participant for stranger' do
      expect(subject).not_to permit(@stranger, @participant_viewer)
    end

    it 'allows destroying participant for stranger' do
      expect(subject).not_to permit(@stranger, @participant_viewer)
    end

  end

end