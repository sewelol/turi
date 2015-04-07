class FriendshipsController < ApplicationController

  before_action :set_user
  before_action :set_request

  def new
    @request = Request.new
  end

  def request
    Request.find(params[:requester_id])
    if params[:re]
      @friendship = current_user.friendships.build(:friend_id => @user.id)
      flash[:notice] = I18n.t 'user_friendship_confirmed'
    else
      flash[:alert] = I18n.t 'user_friendship_not_confirmed'
    end
    request.destroy
    redirect_to user_path @user
  end

  def create
    @request = Request.create(set_request)
    if @request.save
      flash[:notice] = I18n.t 'user_friendship_added'
      redirect_to user_path @user
    else
      flash[:error] = I18n.t 'user_friendship_not_added'
      redirect_to user_path @user
    end
  end

  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = I18n.t 'user_friendship_removed'
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  private

  def set_request
    params.require(:request).permit(:name)
  end

end
