class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

  # Make sure that every action calls "authorize"
  after_action :verify_authorized

  def show
    authorize @user
    
    # Friends of @user
    friends = @user.friends
    friends += @user.inverse_friends
    @friends = Kaminari.paginate_array(friends).page(params[:friends]).per(3)

    # Do a lookup for all public trips the @user is involved in
    public_trips = []
    @user.participants.each do |participant|
        public_trips += Trip.where(:id => participant.trip_id, :public => true) 
    end
    @public_trips = Kaminari.paginate_array(public_trips).page(params[:trips]).per(3)

    @requests = Request.where('(user_id LIKE ? AND receiver_id  LIKE ?) OR (user_id LIKE ? AND receiver_id LIKE ?)', @user.id, current_user.id, current_user.id, @user.id)
    @friendships = Friendship.where('(user_id LIKE ? AND friend_id  LIKE ?) OR (user_id LIKE ? AND friend_id LIKE ?)', @user.id, current_user.id, current_user.id, @user.id)


    
  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :age, :country, :town, :status, :image, :gender)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('user_id_not_found')

    redirect_to dashboard_path
  end
end
