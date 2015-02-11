class DashboardController < ApplicationController
  before_action :require_signin!

  def index
    @trips = Trip.all
  end

end
