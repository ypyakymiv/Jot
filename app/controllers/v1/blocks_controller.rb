class V1::BlocksController < V1::BaseController

  before_action :authenticate_user!
  before_action :set_page, only: [:index]
  before_action :set_user_by_id, except: [:index]

  def index
    @blocks = current_user.blocked_friends
  end

  def create
    if !current_user.blocked_friends.include? @user
      current_user.block_friend @user
    end
  end

  def destroy
    if current_user.blocked_friends.include? @user
      current_user.unblock_friend @user
    end
  end

end
