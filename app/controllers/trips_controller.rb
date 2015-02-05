class TripsController < ApplicationController
    before_action :set_trip, only: [:show, :edit, :update, :destroy]
    before_action :check_for_cancel_create, only: :create
    before_action :check_for_cancel_update, only: :update


    def show
    end

    def new
        @trip = Trip.new
    end

    def create
        @trip = Trip.create(trip_params)

        if @trip.save
            @trip.tag_list.add(trip_params[:tag_list], parse: true) 
            flash[:notice] = "You successfully created a trip"
            redirect_to @trip
        else
            flash[:alert] = "Trip was not created!"
            render :new
        end
    end

    def update
        if @trip.update(trip_params)
            @trip.tag_list.remove(@trip.tag_list, parse: true)
            @trip.tag_list.add(trip_params[:tag_list], parse: true)
            flash[:notice] = "Trip has been updated"
            redirect_to @trip
        else
            flash[:alert] = "Trip has not been updated!"
            render 'edit'
        end
    end

    def edit
    end

    def destroy
        @trip.destroy
        flash[:notice] = "Trip has been deleted"
        redirect_to "/"
        # Remember to delete stuff thats linked that use this trip as a referance!
    end

    private
    def trip_params
        params.require(:trip).permit(:title, :description, :start_loc, :end_loc, :image, :tag_list)
    end

    def set_trip
        @trip = Trip.find(params[:id])
        # Redirect to index(for now) if the trip is not in the database # 
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = "The trip was not found!"
            redirect_to "/"
    end


    #### Can we merge these two into a single function? ####
    def check_for_cancel_create
        if(params.key?("cancel"))
            flash[:notice] = "Trip creation cancelled."
            redirect_to '/'
        end
    end

    def check_for_cancel_update
        if(params.key?("cancel"))
            flash[:notice] = "Trip was not updated."
            redirect_to trip_path
        end
    end
end
