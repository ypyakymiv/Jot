class V1::UsersController < V1::BaseController
  before_action :authenticate_user!, except: [:create]
  before_action :check_if_user, only: [:update, :destroy]
  before_action :set_user_by_id, only: [:show, :update, :destroy]
  before_action :set_query, only: [:index]


  def index
    if @q
      @users = User.search_full_text(@q)
    else
      @users = User.all
    end
  end

  def show
  end

  def create
    @user = User.create(user_params)
    if !@user
      head 400
    elsif !@user.valid?
      render status: 422
    end
  end

  def update
    event_params.each do |k, v|
      @user.send k + "=", v
    end
    if !@user.save
      render status: 422
    else
      render status: 204, nothing: true
    end
  end

  def destroy
    if !@user.destroy
      head 500
    end
    head 200
  end

  def attending
  end

  def friends
    @friends = current_user.friends
  end

  def friend
    if !current_user.friends_with?(@user) && !current_user.requesting?(@user)
      current_user.friend_request @user
    end
  end

  def unfriend
    if current_user.friends_with? @user
      current_user.remove_friend @user
    end
  end

  def accept
  end

  def deny
  end

  def block
  end

  def unblock
  end

  private

  def check_if_user
    head 401 if @user != current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
