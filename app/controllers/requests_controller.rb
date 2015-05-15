class RequestsController < ApplicationController

  before_action :set_user


  def create
    #byebug
    @request = current_user.requests.build(receiver_id: params[:receiver_id])
    receiver = User.find_by_id(params[:receiver_id])
    if current_user.id.eql?(params[:receiver_id].to_i)
      flash[:error] = t 'user_request_not_yourself'
    elsif receiver.eql?(nil)
      flash[:error] = t 'user_request_not_exist'
      redirect_to user_path current_user.id
      return
    elsif @request.save
      flash[:notice] = I18n.t 'user_request_added'
    else
      flash[:error] = I18n.t 'user_request_not_added'
    end
    redirect_to user_path params[:receiver_id]
  end

  def destroy
    @request = Request.find_by_id(params[:id])
    if @request.eql?(nil)
      flash[:alert] = t 'user_request_destroy_not_exist'
    elsif @request.destroy
      flash[:notice] = I18n.t 'user_request_destroyed'
    else
      flash[:alert] = t 'user_request_destroy_not_destroyed'
    end

    redirect_to user_path params[:user_id]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
