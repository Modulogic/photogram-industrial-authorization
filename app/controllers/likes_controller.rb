class LikesController < ApplicationController
  before_action :set_like, only: %i[show edit update destroy]
  before_action :is_an_authorized_user, only: %i[destroy create]
  before_action :ensure_user_is_authorized, only: [:show]

  # GET /likes
  def index
    @likes = Like.all
  end

  # GET /likes/1
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes
  def create
    @like = Like.new(like_params)
    authorize @like

    respond_to do |format|
      if @like.save
        format.html { redirect_back fallback_location: @like.photo, notice: "Like was successfully created." }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  def destroy
    authorize @like
    @like.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: @like.photo, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:fan_id, :photo_id)
  end

  def ensure_user_is_authorized
    authorize @user
  end

  def is_an_authorized_user
    photo = @like&.photo || Photo.find_by(id: params[:like][:photo_id])

    unless photo && (!photo.owner.private? || photo.owner == current_user || current_user.leaders.include?(photo.owner))
      redirect_back(fallback_location: root_url, alert: "Not authorized")
    end
  end
end
