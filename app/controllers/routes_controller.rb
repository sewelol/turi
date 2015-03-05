class RoutesController < ApplicationController

  before_action :authenticate_user!

  layout 'trip'

  def index
    @trip = Trip.find(params[:trip_id])
    @routes = @trip.routes.all
    # @route = Route.find(params[:id])
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @route = Route.find(params[:id])
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @route = Route.new
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @route = Route.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @route = Route.find(params[:id])

    if @route.update(route_params)
      flash[:notice] = I18n.t 'trip_route_updated'
      redirect_to [@trip, @article]
    else
      flash[:alert] = I18n.t 'trip_route_not_updated'
      render 'new'
    end
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @route = @trip.routes.build(route_params)
    if @route.save
      redirect_to [@trip, @route]
    else
      render 'new'
    end
  end

  private
  def route_params
    # params.require(:route).permit(:title, :desc, waypoint_attributes: [:lat, :lng, :description, :type])
    params.require(:route).permit(:title, :desc, waypoints_attributes: [:desc, :lat, :lng, :typ])
  end

end


