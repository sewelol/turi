class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @trips = Trip.all
  end

end
