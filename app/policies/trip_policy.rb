class TripPolicy < ApplicationPolicy

  def show?
    participant?(user, record)
  end

  def update?
    owner_or_editor?(user, record)
  end

  def destroy?
    owner?(user, record)
  end

  private

  def owner?(user, trip)
    participant = Participant.find_by trip_id: trip.id, user_id: user.id
    participant.nil? == false and participant.participant_role.owner?
  end

  def participant?(user, trip)
    participant = Participant.find_by trip_id: trip.id, user_id: user.id
    participant.nil? == false
  end

  def owner_or_editor?(user, trip)
    participant = Participant.find_by trip_id: trip.id, user_id: user.id
    participant.nil? == false and (participant.participant_role.owner? or participant.participant_role.editor?)
  end

end