class ParticipantsController < TripResourceController

  after_action :verify_authorized

  before_action :set_participant, only: [:destroy]

  def index
    # Only participants which can view the trip details are able to see the participant list
    authorize @trip, :show?

    @participants = @trip.participants
  end

  def new
    # Only participants which can edit the trip are able to view the creation form of a participant
    authorize @trip, :update?
  end

  # Creates the participant with the given role if the current user is allowed to execute this action.
  #
  # Note: You can not add an owner as role!
  #
  # Returns a redirect or renders an error
  def create
    # Only participants which can edit the trip are able to add a participant
    authorize @trip, :update?

    participant_user = User.find_by!(email: params[:user_email])

    role = ParticipantRole.viewer

    if params[:editor_flag]
      role = ParticipantRole.editor
    end

    participant = @trip.participants.create(user_id: participant_user.id, participant_role_id: role.id)

    participant.save
    flash[:notice] = I18n.t 'trip_participant_added', :email => participant_user.email
    redirect_to trip_participants_path(@trip)

    rescue ActiveRecord::RecordNotFound

    flash[:alert] = I18n.t 'user_not_found'
    redirect_to new_trip_participant_path(@trip)
  end

  # Removes the participant if the current user is allowed to execute this action.
  # Returns a redirect or renders an error
  def destroy
    # Only participants which can edit the trip are able to remove a participant (except for the owner)
    authorize @participant

    user_email = @participant.user.email
    @participant.destroy
    flash[:notice] = I18n.t 'trip_participant_removed', :email => user_email

    redirect_to trip_participants_path(@trip)
  end

  def set_participant
    @participant = @trip.participants.find(params[:id])
  end

end
