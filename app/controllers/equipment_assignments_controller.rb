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
      
        # Fetch the params
        permitted = params.require(:equipment_assignment).permit(:number, :user_id)

        @equipment_assignment = @equipment_item.equipment_assignments.find_by(user_id: permitted.fetch(:user_id).to_i)
        # If a record where the user_id match the params just update the old one with old value + new value (from
        # params)
        unless @equipment_assignment.nil?
            
            # ruby...
            number = permitted.fetch(:number).to_i + @equipment_assignment.read_attribute(:number)
            if @equipment_assignment.update(:number => number)
                flash[:notice] = I18n.t 'trip_equipment_assignment_created'
                redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
            else 
                flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
                render :new
            end
        # If no record was found, create a new one
        else 
            @equipment_assignment = EquipmentAssignment.create(permitted)

            @equipment_assignment.equipment_item = @equipment_item

            if @equipment_assignment.save
                flash[:notice] = I18n.t 'trip_equipment_assignment_created'
                redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
            else 
                flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
                render :new
            end
        end
    end

    def destroy
        authorize @equipment_assignment

        @equipment_assignment.destroy
        flash[:notice] = I18n.t 'trip_equipment_assignment_deleted'
        redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
    end
end
