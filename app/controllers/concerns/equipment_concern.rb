# EquipmentConcern adds set functions for the equipmentList and its derivatives
module EquipmentConcern
    # include TripConcern for juicy trip functions and authentication
    include TripConcern

    def set_equipment_list(equipment_list)
        @equipment_list = EquipmentList.find(equipment_list)
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_list_not_found'
            redirect_to :back
    end

    def set_equipment_item(equipment_item)
        @equipment_item = EquipmentItem.find(equipment_item)
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_item_not_found'
    end

    def set_equipment_assignment(equipment_assignment)
        @equipment_assignment = EquipmentAssignment.find(equipment_assignment)
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_found'
    end    
end
