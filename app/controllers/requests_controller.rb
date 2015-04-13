class RequestsController < ApplicationController
  before_action :set_request

  def new
    @request = Request.new
  end

  def create
    @request = Request.create(:requester_id => current_user.id, :reciever_id => params[:user_id])
    if @request.save
      flash[:notice] = I18n.t 'user_request_added'
      redirect_to user_path @user
    else
      flash[:error] = I18n.t 'user_request_not_added'
      redirect_to user_path @user
    end
  end

  def destroy
    @request.destroy
    flash[:notice] = I18n.t 'user_request_removed'
  end

  private
  def set_request
    params.require(:request).permit(:user_id)
  end
end
