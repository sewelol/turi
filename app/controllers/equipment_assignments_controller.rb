class EquipmentAssignmentsController <  ApplicationController
    # Include the EquipmentConcern which contains all the set functionality
    include EquipmentConcern
    before_action { |c| c.set_trip params[:trip_id] }
    before_action { |c| c.set_equipment_list params[:equipment_list_id] }
    before_action { |c| c.set_equipment_item params[:equipment_item_id] }
    before_action(:only => [:show, :update, :edit, :destroy]) { |c| c.set_equipment_assignment params[:id] }
    layout 'trip'

    def create
        authorize @trip, :show?
        # Fetch params
        permitted = params.require(:equipment_assignment).permit(:number, :user_id)

        # Do a lookup in the database
        @equipment_assignment = @equipment_item.equipment_assignments.find_by(user_id: permitted[:user_id])

        # If the equipment_assignment exists, update that with the new value
        unless @equipment_assignment.nil?
            if permitted[:number].to_i <= 0
                @equipment_assignment.destroy
                flash[:notice] = I18n.t'trip_equipment_assignment_deleted'
             elsif (permitted[:number].to_i - @equipment_assignment.number) + @equipment_item.equipment_assignments.sum(:number) < @equipment_item.number
                if @equipment_assignment.update(params.require(:equipment_assignment).permit(:number))
                    flash[:notice] = I18n.t 'trip_equipment_assignment_updated'
                else 
                    flash[:alert] = I18n.t 'trip_equipment_assignment_not_updated'
                end
            else 
                flash[:alert] = I18n.t 'trip_equipment_assignment_not_updated'
            end
        # If the equipment_assignment record not exist create a new one
        else 
            unless permitted[:number].to_i + @equipment_item.equipment_assignments.sum(:number) > @equipment_item.number || permitted[:number].to_i <= 0
                @equipment_assignment = EquipmentAssignment.create(permitted)
                @equipment_assignment.equipment_item = @equipment_item

                if @equipment_assignment.save
                    flash[:notice] = I18n.t 'trip_equipment_assignment_created'
                else 
                    flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
                end
            else 
                flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
            end
        end

        redirect_to trip_equipment_list_path(@trip, @equipment_list)
    end

    def destroy
        authorize @equipment_assignment

        @equipment_assignment.destroy
        flash[:notice] = I18n.t 'trip_equipment_assignment_deleted'
        redirect_to trip_equipment_list_path(@trip, @equipment_list)
    end

end
