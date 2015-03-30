class EventsController < TripResourceController

  after_action :verify_authorized

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    authorize @trip, :show?
    @events = @trip.events
    @upcoming_events = @events.where('start_date > ?', DateTime.now).order(:start_date)

    # TODO: Use a new action for json/html
    respond_to do |format|
      format.html { render :index }
      format.json { render json: build_json_event_list }
    end

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

  def build_json_event_list
    events = []

    filter_start_date = DateTime.strptime params[:start], '%Y-%m-%d'
    filter_end_date = DateTime.strptime params[:end], '%Y-%m-%d'

    if ! @trip.start_date.blank? and ! @trip.end_date.blank?
      trip_start_date = DateTime.strptime @trip.start_date, '%m/%d/%y'
      trip_end_date = DateTime.strptime @trip.end_date, '%m/%d/%y'
      if trip_start_date >= filter_start_date and trip_end_date <= filter_end_date
        trip_main_event = {
            :id => "trip-#{@trip.id}",
            :url => trip_path(@trip),
            :title => @trip.title,
            :start => @trip.start_date,
            :end => @trip.end_date
        }
        events.push(trip_main_event)
      end
    end

    @trip.events.where('start_date >= ? AND end_date <= ?', filter_start_date, filter_end_date).each do |trip_event|
      events.push({
                      :id => "trip-event-#{trip_event.id}",
                      :url => trip_event_path(@trip, trip_event),
                      :title => trip_event.name,
                      :start => trip_event.start_date,
                      :end => trip_event.end_date,
                      :color => trip_event.color
                  })
    end

    return events
  end

end
