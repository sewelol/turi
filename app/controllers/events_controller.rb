class EventsController < TripResourceController

  after_action :verify_authorized

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    authorize @trip, :show?
    @events = @trip.events
  end

  def show
    authorize @trip, :show?

    @has_event_coordinates = false

    if @event.location.nil? || @event.location.empty?
      @event_coordinates = nil
    else
      @has_event_coordinates = true
      @event_coordinates = Geocoder.coordinates(@event.location)
    end
  end

  def new
    authorize @trip, :update?
    @event = @trip.events.new
  end

  def edit
    authorize @trip, :update?
  end

  def create
    authorize @trip, :update?
    @event = @trip.events.new(event_params)
    if @event.valid?
      @event.save
      redirect_to trip_event_path @trip, @event
    else
      flash[:alert] = I18n.t 'trip_event_invalid'
      render :new
    end
  end

  def update
    authorize @trip, :update?
    if @event.update(event_params)
      redirect_to trip_event_path @trip, @event
    else
      flash[:alert] = I18n.t 'trip_event_invalid'
      render :edit
    end
  end

  def destroy
    authorize @trip, :update?
    @event.destroy
    flash[:notice] = I18n.t 'trip_event_destroyed'
    redirect_to trip_events_path @trip
  end

  private

  def set_event
    @event = @trip.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_date, :end_date, :color)
  end

end
