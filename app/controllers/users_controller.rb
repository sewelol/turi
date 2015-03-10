class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

  def show
    @current_user = current_user
  end

  def edit
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
    params.require(:user).permit(:name, :email, :age, :country, :town, :status, :image)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('user_id_not_found')

    redirect_to dashboard_path
  end
end
