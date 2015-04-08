class App::ExploreController < ApplicationController

  before_action :authenticate_user!

  def index
    @trips = Trip.all

    @trip_items = []

    @trips.each do |trip|
      unless trip.start_loc.blank?
        trip_coordinates = Geocoder.coordinates(trip.start_loc)
        trip_item = {
            lat: trip_coordinates[0],
            long: trip_coordinates[1]
        }
        @trip_items.push(trip_item)
      end
    end

  end

end
