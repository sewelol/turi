class CommentsController < TripResourceController
  before_action :set_discussion
  before_action :set_comment, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def new
    authorize @trip, :show?
    @comment = Comment.new
  end

  def create
    authorize @trip, :show?
    @comment = @discussion.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html {
          flash[:notice] = "Comment has been created."
          redirect_to [@trip, @discussion] }
        format.js {
          # look at view/comment/create.js.erb
        }
      else
        flash[:alert] = "Comment has not been created"
        render :new
      end
    end
  end

  def edit
    authorize @trip, :update?
  end

  def update
    authorize @trip, :update?
    if @comment.update(comment_params)
      flash[:notice] = "Comment has been updated."
      redirect_to [@trip, @discussion]
    else
      flash[:alert] = "Comment has not been updated."
      render :edit
    end
  end

  def destroy
    authorize @trip, :update?
    @comment.destroy
    flash[:notice] = "Comment has been deleted."

    redirect_to [@trip, @discussion]
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_discussion
    @discussion = @trip.discussions.find(params[:discussion_id])
  end

  def set_comment
    @comment = @discussion.comments.find(params[:id])
  end
end
