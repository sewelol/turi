# TripConcern adds set function and authentication for trips and its derivatives
module TripConcern
    extend ActiveSupport::Concern

    # simular to a before_action in a controller!
    included do
        :authenticate_user!
    end

    def set_trip(trip)
        @trip = Trip.find(trip)
    rescue ActiveRecord::RecordNotFound
        flash[:alert] = I18n.t 'trip_not_found'
        redirect_to :back
    end
end
