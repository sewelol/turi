class TripsController < ApplicationController
    before_action :set_trip, only: [:show, :edit, :update, :destroy]
    before_action :check_for_cancel_create, only: :create
    before_action :check_for_cancel_update, only: :update
    before_action :require_signin!, except: [:show]


    def show
    end

    def new
        @trip = Trip.new
    end

    def create
        @trip = Trip.create(trip_params)

        @trip.account = current_user

        if @trip.save
            @trip.tag_list.add(trip_params[:tag_list], parse: true) 
            flash[:notice] = I18n.t 'trip_created'
            redirect_to @trip
        else
            flash[:alert] = I18n.t 'trip_not_created'
            render :new
        end
    end

    def update

        

        if @trip.update(trip_params)
            @trip.tag_list.remove(@trip.tag_list, parse: true)
            @trip.tag_list.add(trip_params[:tag_list], parse: true)
            flash[:notice] = I18n.t 'trip_updated'
            redirect_to @trip
        else
            flash[:alert] = I18n.t 'trip_not_updated'
            render 'edit'
        end
    end

    def edit
        if current_user.id != @trip.account_id
            flash[:error] = I18n.t 'trip_edit_permission_error'
            redirect_to @trip
        end
    end

    def destroy
        if current_user.id == @trip.account_id
            @trip.destroy
            flash[:notice] = I18n.t 'trip_deleted'
            redirect_to dashboard_path
        else
            flash[:error] = I18n.t 'trip_delete_permission_error'
            redirect_to @trip
        end

        # Remember to delete stuff thats linked that use this trip as a referance!
    end

    private
    def trip_params
        params.require(:trip).permit(:title, :description, :start_loc, :start_date, :end_loc, :end_date, :image, :tag_list)
    end

    def set_trip
        @trip = Trip.find(params[:id])
        # Redirect to index(for now) if the trip is not in the database # 
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_not_found'
            redirect_to dashboard_path
    end


    #### Can we merge these two into a single function? ####
    def check_for_cancel_create
        if(params.key?("cancel"))
            flash[:notice] = I18n.t 'trip_create_canceled'
            redirect_to dashboard_path
        end
    end

    def check_for_cancel_update
        if(params.key?("cancel"))
            flash[:notice] = I18n.t 'trip_not_updated'
            redirect_to trip_path
        end
    end

    


end
