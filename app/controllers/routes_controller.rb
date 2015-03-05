class RoutesController < ApplicationController

  before_action :authenticate_user!

  layout 'trip'

  def index
    @trip = Trip.find(params[:trip_id])
  end

  def show

  end

  def new

    @trip = Trip.find(params[:trip_id])

  end

  def create
    @trip = Trip.find(params[:trip_id])

    @route = Route.new(route_params)



    # redirect_to trip_route_path
  end



  private
  def route_params
    params.require(:route).permit(:title, :desc)
  end

end


