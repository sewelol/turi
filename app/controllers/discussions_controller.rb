class DiscussionsController < TripResourceController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize @trip, :show?
    @discussions = @trip.discussions
  end

  def new
    authorize @trip, :show?
    @discussion = Discussion.new
  end

  def create
    authorize @trip, :show?
    @discussion = @trip.discussions.build(discussion_params)
    @discussion.user = current_user
    if @discussion.save
      flash[:notice] = "Discussion has been created."
      redirect_to [@trip, @discussion]
    else
      flash[:alert] = "Discussion has not been created"
      render "new"
    end
  end

  def show
    authorize @trip, :show?
    @comments = @discussion.comments
  end

  def edit
    authorize @trip, :update?
  end

  def update
    authorize @trip, :update?
    if @discussion.update(discussion_params)
      flash[:notice] = "Discussion has been updated."
      redirect_to [@trip, @discussion]
    else
      flash[:alert] = "Discussion has not been updated."
      render "edit"
    end
  end

  def destroy
    authorize @trip, :update?
    @discussion.destroy
    flash[:notice] = "Discussion has been deleted."

    redirect_to trip_discussions_path @trip
  end

  private
  def discussion_params
    params.require(:discussion).permit(:title, :body)
  end

  def set_discussion
    @discussion = @trip.discussions.find(params[:id])
  end
end
