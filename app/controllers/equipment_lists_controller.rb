class EquipmentListsController < ApplicationController

    # Include the EquipmentConcern which contains all the set functionality
    include EquipmentConcern
    
    before_action { |c| c.set_trip params[:trip_id] }
    before_action(:only => [:show, :update, :edit, :destroy]) { |c| c.set_equipment_list params[:id] }
    before_action { |c| c.equipment_lists_users_summary @trip.equipment_lists }
    layout 'trip'


    def index 
        @equipment_lists = @trip.equipment_lists
    end

    def show 
        @equipment_item = EquipmentItem.new
        

        # Item and cost summary for all participants for the spesfic trip,
        # used for the charts in the show trip page. 
        # Very simulare to the trips summary, just for one spesific trip, we might be able to combine these(?)
        @total_amount = 0
        @total_items = 0
        @equipment_list.equipment_items.each do |f|
            @total_amount += f.number * f.price
            @total_items += f.number
        end

        total_amount_remaining = @total_amount
        total_item_remaining = @total_items


        @list = Hash.new
        @trip.participants.each do |participant| 
            @list[participant.user_id] = [0,0]
        end

        @current_user_assignments = []

        @equipment_list.equipment_items.each do |item|
            item.equipment_assignments.each do |assignment|
                if assignment.user_id == current_user.id
                    @current_user_assignments.push assignment
                end
                hash_entry = @list[assignment.user_id]
                hash_entry[0] += (assignment.number * item.price)
                total_amount_remaining -= (assignment.number * item.price)
                hash_entry[1] += assignment.number
                total_item_remaining -= assignment.number
                @list[assignment.user_id] = hash_entry
            end
        end

        @list['not assigned'] = [total_amount_remaining, total_item_remaining]
        @total_item_remaining = total_item_remaining
    end

    def new
        authorize @trip, :update?
        @equipment_list = EquipmentList.new
    end

    def create
        # Reuse the update policy from the trip, since only editors and owner can create a new EquipmentList
        authorize @trip, :update?
        @equipment_list = EquipmentList.create(equipment_list_params)
        @equipment_list.trip = @trip
        @equipment_list.user = current_user
        
        if @equipment_list.save
            #flash[:notice] = I18n.t 'trip_equipment_list_created'
            redirect_to trip_equipment_list_path(@trip.id, @equipment_list)
        else 
            #flash[:alert] = I18n.t 'trip_equipment_list_not_created'
            render :new
        end
    end

    def update
        authorize @trip
        if @equipment_list.update(equipment_list_params)
            #flash[:notice] = I18n.t 'trip_equipment_list_updated'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            #flash[:alert] = I18n.t 'trip_equipment_list_not_updated'
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
