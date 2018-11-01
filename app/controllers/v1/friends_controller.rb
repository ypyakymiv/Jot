class V1::FriendsController < V1::BaseController

  before_action :authenticate_user!
  before_action :set_user_by_id, except: [:index]

  def index
    @friends = current_user.friends
  end

  def create
    if has_relationship_to? @user
      head 422
    else
      current_user.friend_request @user
    end
  end

  def destroy
    if !current_user.friends_with? @user
      head 422
    else
      current_user.remove_friend @user
    end
  end

  private

  def has_relationship_to? user
    current_user.friends_with?(user) || current_user.pending_friends.include?(user)
  end

end
