class RequestsController < ApplicationController

  before_action :set_user

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(:user_id => current_user.id, :receiver_id => params[:receiver_id])
    #puts "in params we have #{params} and specifically #{params[:user_id]}. current user id: #{current_user.id}"
    rec = User.find_by_id(params[:receiver_id])
    #puts rec.inspect
    #puts "record is #{rec}"
    #byebug
    if current_user.id.eql?(params[:receiver_id].to_i)
      flash[:error] = t 'user_request_not_yourself'
    elsif rec == nil
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

    redirect_to user_path current_user.id
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
