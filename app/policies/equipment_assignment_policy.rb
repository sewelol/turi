# Authorization for equipment Assigments
class EquipmentAssignmentPolicy < ApplicationPolicy
    def update?
        assigment_owner || Pundit.policy(@user, @record.equipment_item.equipment_list.trip).update?
    end

    def destroy?
        assigment_owner || Pundit.policy(@user, @record.equipment_item.equipment_list.trip).destroy?
    end

    def create?
        assigment_owner || Pundit.policy(@user, @record.equipment_item.equipment_list.trip).create?
    end

    def assigment_owner
        @user.id == @record.user_id
    end
end
