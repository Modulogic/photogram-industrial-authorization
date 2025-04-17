class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show liked feed discover]
  before_action :authorize_user, only: %i[show feed discover]

  # Override Pundit's error handler just for this controller
  rescue_from Pundit::NotAuthorizedError, with: :redirect_home

  # GET /users
  def index
    @users = @q.result
  end

  # GET /:username
  def show
    # @user loaded & authorized
  end

  # GET /:username/liked
  def liked
    @photos = @user.liked_photos
  end

  # GET /:username/feed
  def feed
    @photos = @user.feed
  end

  # GET /:username/discover
  def discover
    @photos = @user.discover
  end

  private

  def set_user
    @user = if params[:username]
      User.find_by!(username: params.fetch(:username))
    else
      current_user
    end
  end

  def authorize_user
    case action_name
    when "show"
      authorize @user, :show?
    when "feed"
      authorize @user, :feed?
    when "discover"
      authorize @user, :discover?
    end
  end

  def redirect_home
    redirect_to root_path, alert: "You're not authorized for that"
  end
end
