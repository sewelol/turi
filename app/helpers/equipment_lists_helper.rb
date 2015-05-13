module EquipmentListsHelper

  def find_assignment_by_participant_or_new(item, participant)
    assignment = item.equipment_assignments.find_by(user_id: participant.user_id)
    if assignment.nil?
      assignment = EquipmentAssignment.new
      assignment.number = 0
    end
    return assignment
  end

end
