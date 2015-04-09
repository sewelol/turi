class CommentsController < TripResourceController
  before_action :set_discussion
  after_action :verify_authorized

  def create
    authorize @trip, :show?
    @comment = @discussion.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js {
          # look at view/comment/create.js.erb
        }
      else
        format.js {
          ""
        }
      end
    end
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
