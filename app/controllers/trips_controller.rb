class TripsController < ApplicationController
    before_action :set_trip, only: [:show, :edit, :update, :destroy]

    def show
    end

    def new
        @trip = Trip.new
    end

    def create
        @trip = Trip.create(trip_params)

        if @trip.save
            flash[:notice] = "You successfully created a trip"
            redirect_to @trip
        else
            flash[:alert] = "Trip was not created!"
            render :new
        end
    end

    def update
        if @trip.update(trip_params)
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
        params.require(:trip).permit(:title, :description, :start_loc, :end_loc, :image)
    end

    def set_trip
        @trip = Trip.find(params[:id])
        # Redirect to index(for now) if the trip is not in the database # 
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = "The trip was not found!"
            redirect_to "/"
    end

end
