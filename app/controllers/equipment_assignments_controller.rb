class EquipmentAssignmentsController <  ApplicationController
    # Include the EquipmentConcern which contains all the set functionality
    include EquipmentConcern
    before_action { |c| c.set_trip params[:trip_id] }
    before_action { |c| c.set_equipment_list params[:equipment_list_id] }
    before_action { |c| c.set_equipment_item params[:equipment_item_id] }
    before_action(:only => [:show, :update, :edit, :destroy]) { |c| c.set_equipment_assignment params[:id] }
    layout 'trip'

    def create
        @equipment_assignment = EquipmentAssignment.create(equipment_assignment_params)

        @equipment_assignment.equipment_item_id = @equipment_item.id
        # FIXME Some kind of authorize error(!?)
        #authorize @equipment_assignment 

        if @equipment_assignment.save
            flash[:notice] = I18n.t 'trip_equipment_assignment_created'
            redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
        else 
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
            render :new
        end
    end

    def edit
        authorize @equipment_assignment
        render 'edit' 
    end

    def update
        authorize @equipment_assignment

        if @equipment_assignment.update(equipment_assignment_params)
            flash[:notice] = I18n.t 'trip_equipment_assignment_updated'
            redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
        else 
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_updated'
            render 'edit'
        end
    end

    def destroy
        authorize @equipment_assignment

        @equipment_assignment.destroy
        flash[:notice] = I18n.t 'trip_equipment_assignment_deleted'
        redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
    end


    private
    def equipment_assignment_params
        params.require(:equipment_assignment).permit(:number, :user_id)
    end
end
