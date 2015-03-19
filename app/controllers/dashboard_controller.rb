class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @trips = current_user.trips
  end

end
