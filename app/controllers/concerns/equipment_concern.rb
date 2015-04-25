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

    # hash map is used for sidebar user item summary and basic staticsic on the index page     
    def equipment_lists_users_summary(lists)
        @total_amount_summary = 0
        @total_items_summary = 0
        
        lists.each do |list| 
            list.equipment_items.each do |item|
                @total_amount_summary += item.number * item.price
                @total_items_summary += item.number
            end
        end
        total_amount_remaining = @total_amount_summary
        total_item_remaining = @total_items_summary

        # Create a hash of the participants of the trip
        @user_summary_hash = Hash.new
        @trip.participants.each do |participant| 
            @user_summary_hash[participant.user_id] = [0, 0, []]
        end
        
        # Go through all assigments for the trip
        lists.each do |list| 
            list.equipment_items.each do |item|
                item.equipment_assignments.each do |assigment|
                    # FIXME there should be a much better way to do this!
                    hash_entry = @user_summary_hash[assigment.user_id]
                    hash_entry[0] += (assigment.number * item.price)
                    total_amount_remaining -= (assigment.number * item.price)
                    hash_entry[1] += assigment.number
                    total_item_remaining -= assigment.number
                    hash_entry[2].push(assigment)
                    @user_summary_hash[assigment.user_id] = hash_entry
                end
            end
        end
        # One hash entry for not assigned items 
        @user_summary_hash["not assigned"] = [total_amount_remaining, total_item_remaining]
        @total_item_remaining_summary = total_item_remaining
    end
end
