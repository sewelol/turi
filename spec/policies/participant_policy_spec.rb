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

    it 'denies destroying participant for stranger/viewer' do
      expect(subject).not_to permit(@stranger, @participant_viewer)
      expect(subject).not_to permit(@viewer, @participant_viewer)
    end

    it 'denies destroying participant owner for owner/editor/viewer' do
      expect(subject).not_to permit(@owner, @participant_owner)
      expect(subject).not_to permit(@editor, @participant_owner)
      expect(subject).not_to permit(@viewer, @participant_owner)
    end

    it 'allows destroying participant for owner/editor' do
      expect(subject).to permit(@owner, @participant_viewer)
      expect(subject).to permit(@editor, @participant_viewer)
    end

  end

end