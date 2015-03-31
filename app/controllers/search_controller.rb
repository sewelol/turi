class SearchController < ApplicationController

  before_action :authenticate_user!

  def index
    render :trips
  end

  def trips
    @trips = Trip.search(params[:title_search], params[:location_search], params[:tag_search], params[:date_beg], params[:date_end])
  end

  def users
    @users = User.search(params[:name_search])
  end

end