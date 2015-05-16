class FriendshipsController < ApplicationController

  before_action :set_user

  def create
    #pp "params are: #{params}"

    exist = Friendship.request_exists(params[:user_id], params[:friend_id])

    if exist
      friendship = current_user.friendships.build(friend_id: params[:friend_id])
      if friendship.save
        flash[:notice] = I18n.t 'user_friendship_confirmed'
        friendRequest = current_user.inverse_requests.where("receiver_id = ?", @user.id)
        if friendRequest.blank?
          friendRequest = current_user.requests.where("user_id = ?", @user.id)
        end
        friendRequest[0].destroy
      else
        flash[:alert] = t('user_friendship_not_confirmed')
      end
    else
      flash[:alert] = I18n.t 'user_friendship_not_confirmed'
    end
    redirect_to user_path @user
  end

  def destroy
    # not use global value if you not need it in the view!
    friendship = Friendship.find(params[:id])

    if friendship.nil?
      flash[:alert] = I18n.t('user_friendship_not_removed')
    elsif friendship.destroy
      flash[:notice] = I18n.t 'user_friendship_removed'
    else
      flash[:alert] = I18n.t('user_friendship_not_removed')
    end
    redirect_to current_user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
