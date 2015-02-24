class ParticipantPolicy < ApplicationPolicy

  def destroy?

    participant = Participant.find_by trip_id: record.trip.id, user_id: user.id

    # Make sure that the current_user is a participant of the trip.
    if(participant.nil?)
      return false
    end

    # Make sure that the owner can not be removed.
    if(record.participant_role.owner?)
      return false
    end

    # Otherwise allow all participants which can edit the trip to remove the participant
    Pundit.policy(user, record.trip).update?

  end

end