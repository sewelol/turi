class RoutesController < TripResourceController

  def index
    @routes = @trip.routes.all
    # @route = Route.find(params[:id])
  end

  def show
    @route = Route.find(params[:id])
  end

  def new
    authorize @trip, :update?

    @route = Route.new
  end
  


  def create
    authorize @trip, :update?

    @route = @trip.routes.build(route_params)
    if @route.save
      flash[:notice] = I18n.t 'trip_add_route'
      redirect_to [@trip, @route]
    else
      flash[:alert] = I18n.t 'trip_add_route_failed'
      render 'new'
    end
    # redirect_to trip_route_path
  end

  def edit
    authorize @trip, :update?
    @route = @trip.routes.find(params[:id])
    render 'edit'
  end

  def update
    authorize @trip, :update?
    @route = @trip.routes.find(params[:id])

    if @route.update(route_params)
      flash[:notice] = I18n.t 'trip_route_updated'
      redirect_to [@trip, @article]
    else
      flash[:alert] = I18n.t 'trip_route_not_updated'
      render 'edit'
    end
  end

  def destroy

    # The owner and other editors are allowed to destroy the route
    authorize @trip, :update?
    @route = @trip.routes.find(params[:id])

    @route.destroy
    flash[:notice] = I18n.t 'trip_route_deleted'
    redirect_to trip_routes_path(@trip)
  end

  private
  def route_params
    # params.require(:route).permit(:title, :desc, waypoint_attributes: [:lat, :lng, :description, :type])
    params.require(:route).permit(:title, :desc, waypoints_attributes: [:desc, :lat, :lng, :typ])
  end

end


