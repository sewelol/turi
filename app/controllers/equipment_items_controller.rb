class EquipmentItemsController < ApplicationController
    # Include the EquipmentConcern which contains all the set functionality 
    include EquipmentConcern
    before_action { |c| c.set_trip params[:trip_id] }
    before_action { |c| c.set_equipment_list params[:equipment_list_id] }
    before_action(:only => [:update, :edit, :destroy]) { |c| c.set_equipment_item params[:id] }
    before_action { |c| c.equipment_lists_users_summary @trip.equipment_lists }

    layout 'trip'

    def create
        @equipment_item = EquipmentItem.create(equipment_item_params)
        @equipment_item.equipment_list = @equipment_list
        @equipment_item.user_id = current_user.id

        authorize @equipment_item        

        if @equipment_item.save 
            flash[:notice] = I18n.t 'trip_equipment_item_created'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            flash[:alert] = I18n.t 'trip_equipment_item_not_created'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        end
    end

    def update
        authorize @equipment_item
        if @equipment_item.update(equipment_item_params)
            flash[:notice] = I18n.t 'trip_equipment_item_updated'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            flash[:alert] = I18n.t 'trip_equipment_item_not_updated'
            render :edit
        end
    end

    def edit
        authorize @equipment_item
        render :edit
    end

    def destroy
        authorize @equipment_item

        @equipment_item.destroy
        flash[:notice] = I18n.t 'trip_equipment_item_deleted'
        redirect_to trip_equipment_list_path(@trip, @equipment_list)
    end

    private
    def equipment_item_params
        params.require(:equipment_item).permit(:name, :price, :number)
    end
end
