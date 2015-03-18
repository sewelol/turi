class RoutesController < ApplicationController
  before_action :authenticate_user!

  layout 'trip'

  def index
    @trip = Trip.find(params[:trip_id])
    @routes = Route.all
    # @route = Route.find(params[:id])
  end

  def show
    @trip = Trip.find(params[:trip_id])

  end

  def new

    # @route = Route.new(route_params)
    @trip = Trip.find(params[:trip_id])

    @route = Route.new

  end


  def create
    pp params

    @trip = Trip.find(params[:trip_id])

    @route = Route.create(route_params)



    # redirect_to trip_route_path
  end



  private
  def route_params
    params.require(:route).permit(:title, :desc)
    # params.require(:route).permit(:title, :desc, waypoint_attributes: [:lat, :lng, :description, :type])
  end

end


