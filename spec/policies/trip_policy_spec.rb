require 'rails_helper'

describe TripPolicy do

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

  permissions :show? do

    it 'denies show trip for stranger' do
      expect(subject).not_to permit(@stranger, @trip)
    end

    it 'allows show trip for viewer/editor/owner' do
      expect(subject).to permit(@viewer, @trip)
      expect(subject).to permit(@editor, @trip)
      expect(subject).to permit(@owner, @trip)
    end

  end

  permissions :update? do

    it 'denies update trip for stranger/viewer' do
      expect(subject).not_to permit(@stranger, @trip)
      expect(subject).not_to permit(@viewer, @trip)
    end

    it 'allows update trip for editor/owner' do
      expect(subject).to permit(@editor, @trip)
      expect(subject).to permit(@owner, @trip)
    end

  end

  permissions :destroy? do

    it 'denies destroy trip for stranger/viewer/editor' do
      expect(subject).not_to permit(@stranger, @trip)
      expect(subject).not_to permit(@viewer, @trip)
      expect(subject).not_to permit(@editor, @trip)
    end

    it 'allows update trip for owner' do
      expect(subject).to permit(@owner, @trip)
    end

  end

end