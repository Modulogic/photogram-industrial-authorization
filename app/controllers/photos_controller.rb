class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo,            only: %i[show edit update destroy]
  before_action :authorize_photo,      only: %i[show edit update destroy]

  # GET /photos
  def index
    @photos = policy_scope(Photo)
  end

  # GET /photos/1
  def show
    # @photo is already authorized
  end

  # GET /photos/new
  def new
    @photo = Photo.new
    authorize @photo
  end

  # GET /photos/1/edit
  def edit
    # @photo is already authorized for update
  end

  # POST /photos
  def create
    @photo = current_user.own_photos.build(photo_params)
    authorize @photo

    if @photo.save
      redirect_to @photo, notice: "Photo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/1
  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: "Photo was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1
  def destroy
    @photo.destroy
    redirect_back fallback_location: root_path,
                  notice: "Photo was successfully destroyed."
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def authorize_photo
    authorize @photo
  end

  def photo_params
    params.require(:photo).permit(:image, :caption)
  end
end
