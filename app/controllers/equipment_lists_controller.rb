class EquipmentListsController < ApplicationController

    # Include the EquipmentConcern which contains all the set functionality
    include EquipmentConcern
    before_action { |c| c.set_trip params[:trip_id] }
    before_action(:only => [:show, :update, :edit, :destroy]) { |c| c.set_equipment_list params[:id] }
    layout 'trip'

    def index 
        @equipment_lists = @trip.equipment_lists
    end

    def show 
        @equipment_item = EquipmentItem.new
    end

    def new
        authorize @trip, :update?
        @equipment_list = EquipmentList.new
    end

    def create
        # Reuse the update policy from the trip, since only editors and owner can create a new EquipmentList
        authorize @trip, :update?
        @equipment_list = EquipmentList.create(equipment_list_params)
        @equipment_list.trip_id = @trip.id
        
        if @equipment_list.save
            flash[:notice] = I18n.t 'trip_equipment_list_created'
            redirect_to trip_equipment_list_path(@trip.id, @equipment_list)
        else 
            flash[:alert] = I18n.t 'trip_equipment_list_not_created'
            render :new
        end
    end

    def update
        authorize @trip
        if @equipment_list.update(equipment_list_params)
            flash[:notice] = I18n.t 'trip_equipment_list_updated'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            flash[:alert] = I18n.t 'trip_equipment_list_not_updated'
            render 'edit'
        end
    end

    def edit
        authorize @trip, :update?
        render 'edit'
    end

    def destroy
        authorize @trip
        
        @equipment_list.destroy
        flash[:notice] = I18n.t 'trip_equipment_list_deleted'
        redirect_to trip_path(@trip)
    end

    def equipment_list_params
        params.require(:equipment_list).permit(:name, :description, :icon)
    end
end
