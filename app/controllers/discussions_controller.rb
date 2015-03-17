class DiscussionsController < ApplicationController

  def index
    @discussions = Discussion.all
    render 'index'
  end

  def show
  end
end
