class V1::ThreadsController < V1::BaseController
  before_action :authenticate_user!
  before_action :set_thread_by_id
  # before_action :verify_thread_owner

  def show
  end

  private

  def set_thread_by_id
    @thread = Commontator::Thread.find_by_id(params[:id])

    if !@thread
      head 404
    end
  end

  def verify_thread_owner
    # assumes that commontable is an event.. which it always will be

    if @thread.commontable.owner != current_user
      head 401
    end
  end

end
