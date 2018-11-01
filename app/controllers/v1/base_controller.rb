class V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json


  protect_from_forgery with: :null_session
  before_action :set_default_response_format

  protected

  def set_page
    @page = params[:page] || 1
  end

  def set_user_by_id
    @user = User.find_by_id(params[:id]||params[:user_id])
    if !@user
      head 404
    end
  end

  def set_default_response_format
    request.format = :json
  end

  def set_query
    @q = params[:q] if params[:q]
  end

  def set_location
    if loc_params
      @loc = loc_params
    else
      render status: 422
    end
  end

  def set_radius
    if params[:rad]
      @rad = params[:rad].to_i
    else
      @rad = 5
    end
  end

  def loc_params
    params.require([:lat, :lng])
  end

  rescue_from ActionController::ParameterMissing, with: :bad_params
  rescue_from ActionController::UnpermittedParameters, with: :bad_params

  private

  def bad_params
    head 400
  end

end
