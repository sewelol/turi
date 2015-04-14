class EquipmentListsController < ApplicationController

    # Include the EquipmentConcern which contains all the set functionality
    include EquipmentConcern
    before_action { |c| c.set_trip params[:trip_id] }
    before_action(:only => [:show, :update, :edit, :destroy]) { |c| c.set_equipment_list params[:id] }
    layout 'trip'

    def index 
        @equipment_lists = @trip.equipment_lists

        @total_amount = 0
        @total_items = 0
        @equipment_lists.each do |list| 
            list.equipment_items.each do |item|
                @total_amount += item.number * item.price
                @total_items += item.number
            end
        end
        total_amount_remaining = @total_amount
        total_item_remaining = @total_items

        # Create a hash of the participants of the trip
        @list = Hash.new
        @trip.participants.each do |participant| 
            @list[participant.user_id] = [0, 0]
        end
        
        # Go through all assigments for the trip
        @equipment_lists.each do |list| 
            list.equipment_items.each do |item|
                item.equipment_assignments.each do |assigment|
                    # FIXME there should be a much better way to do this!
                    hash_entry = @list[assigment.user_id]
                    hash_entry[0] += (assigment.number * item.price)
                    total_amount_remaining -= (assigment.number * item.price)
                    hash_entry[1] += assigment.number
                    total_item_remaining -= assigment.number
                    @list[assigment.user_id] = hash_entry
                end
            end
        end
        # One hash entry for not assigned items 
        @list["not assigned"] = [total_amount_remaining, total_item_remaining] 
        @total_item_remaining = total_item_remaining

    end

    def show 
        @equipment_item = EquipmentItem.new

        @total_amount = 0
        @total_items = 0
        @equipment_list.equipment_items.each do |f|
            @total_amount += f.number * f.price
            @total_items += f.number
        end

        total_sum = 0
        total_items_count = 0
        @participants_list = []
        @trip.participants.each do |participant| 
            sum = 0
            number_of_items = 0
            @equipment_list.equipment_items.each do |item| 
                EquipmentAssignment.where(:user_id => participant.user_id, :equipment_item => item).each do |assigment| 
                    sum += assigment.number * item.price
                    number_of_items += assigment.number
                end 
            end
            if sum != 0
                @participants_list.push([participant.user.name, sum, number_of_items])
                total_sum += sum
                total_items_count += number_of_items
            end
        end       
        if total_sum != @total_amount 
            @participants_list.push(["Not assigned", @total_amount - total_sum, @total_items - total_items_count])
        end
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
