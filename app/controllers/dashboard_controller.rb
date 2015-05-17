class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    trips = []
    current_user.participants.each do |participant|
       trips += Trip.where(:id => participant.trip_id) 
    end
    @trips = Kaminari.paginate_array(trips).page(params[:page]).per(6)
  end

end
