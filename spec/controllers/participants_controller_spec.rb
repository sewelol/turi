require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do

  before :each do
    @owner = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @owner.id)
    @participant_user = FactoryGirl.create(:user)
  end

  describe '#destroy' do

    context 'as trip owner' do
      it 'removes a participant from the current trip'
      it 'renders the :index view with a success message'
    end

    context 'as trip editor' do
      it 'removes a participant from the current trip'
      it 'renders the :index view with a success message'
    end

    context 'as trip viewer' do
      it 'does not remove a participant from the current trip' do
        participant = @trip.participants.create(participant_role_id: ParticipantRole.viewer.id, user_id: @participant_user.id)
        sign_in @participant_user
        delete :destroy, trip_id: @trip, id: participant.id
        expect(response).to redirect_to(trip_participants_path(@trip))
      end
      it 'renders the :index view with a error message' do

      end
    end

  end

end
