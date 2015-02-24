class ParticipantPolicy < ApplicationPolicy

  def create?
    return is_owner_or_editor? user, record.trip
  end

  # Only allow the owner and editor to remove participants
  def destroy?
    return is_owner_or_editor? user, record.trip
  end

  private

  def is_owner_or_editor? user, trip

    if user.id == trip.user_id
      return true
    end

    participant = Participant.find_by trip_id: trip.id, user_id: user.id

    if participant.nil? == false and participant.participant_role.name == 'editor'
      return true
    end

    return false

  end

end