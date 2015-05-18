#*
# This controller allows you to implement a view in a trip context.
#
# === Description
#
# <ul>
#  <li>Checks for an authenticated user</li>
#  <li>Checks if the current user can view the trip</li>
#  <li>Sets the layout to 'trip'</li>
#  <li>Sets +@trip+ to the passed trip_id parameter</li>
#  <li>Raises an error when the trip is not found and redirects to the dashboard.
# </ul>
#
# === Note
#
# Only nested trip resources should extend this controller.
class TripResourceController < ApplicationController

  layout 'trip'

  before_action :authenticate_user!
  before_action :set_trip
  before_action :authorize_user!

  protected

  def authorize_user!
    authorize @trip, :show?
  end

  def set_trip
    @trip = Trip.find params[:trip_id]
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t 'trip_not_found'
    redirect_to dashboard_path
  end

end