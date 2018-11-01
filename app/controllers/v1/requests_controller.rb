class V1::RequestsController < V1::BaseController

  before_action :authenticate_user!
  before_action :set_user_by_id, except: [:requests, :pending]

  def requests
    @requests = current_user.requested_friends
  end

  def pending
    @pending = current_user.pending_friends
  end

  def create
    if !current_user.requested_friends.include? @user
      head 422
    else
      current_user.accept_request @user
    end
  end

  def destroy
    if current_user.pending_friends.include? @user
      @user.decline_request current_user
    elsif current_user.requested_friends.include? @user
      current_user.decline_request @user
    else
      head 422
    end
  end

end
