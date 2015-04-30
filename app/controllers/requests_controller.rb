class RequestsController < ApplicationController

  before_action :set_user

  def new
    @request = Request.new
  end

  def create
    @request = Request.create(:user_id => current_user.id, :receiver_id => params[:user_id])
    if @request.save
      flash[:notice] = I18n.t 'user_request_added'
      redirect_to user_path current_user
    else
      flash[:error] = I18n.t 'user_request_not_added'
      redirect_to user_path current_user
    end
  end

  def destroy
    @request.destroy
    flash[:notice] = I18n.t 'user_request_removed'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
  
end
