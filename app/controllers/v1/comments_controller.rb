class V1::CommentsController < V1::BaseController
  before_action :authenticate_user!
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :verify_ownership, only: [:update, :destroy]

  def show
  end

  def create
    @comment = Commontator::Comment.create(comment_params)
    if !@comment
      head 400
    elsif !@comment.valid?
      render status: 422
    end
  end


  # check if it automatically sets editor or not

  def update
    event_params.each do |k, v|
      @comment.send k + "=", v
    end
    if !@comment.save
      render status: 422
    end
  end

  # find a better error for these requests

  def destroy
    if !@comment.destroy
      head 400
    end
    head 200
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Commontator::Comment.find_by_id(params[:id])
    if !@comment
      head 404
    end
  end

  def verify_ownership
    head 401 if @comment.creator != current_user
  end

end
