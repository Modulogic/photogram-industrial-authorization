class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Devise: sign in required
  before_action :authenticate_user!

  # Setup search bar (if user signed in)
  before_action :set_user_search, if: -> { current_user.present? }

  # Permit extra Devise params
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Verify authorization for all actions except Devise and index
  after_action :verify_authorized, unless: -> {
    devise_controller? || action_name == "index"
  }

  # Modern browser requirement
  allow_browser versions: :modern

  # Pundit error handling
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :private, :name, :bio, :website, :avatar_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :private, :name, :bio, :website, :avatar_image])
  end

  def set_user_search
    @q = User.where.not(id: current_user.id).ransack(params[:q])
  end

  private

  def user_not_authorized
    render plain: "You're not authorized for that", status: :not_found
  end
end
