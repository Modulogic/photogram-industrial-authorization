class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments
  def index
    @comments = policy_scope(Comment)
  
    # If user is not allowed to see any comments, raise a 404 error
    raise Pundit::NotAuthorizedError if @comments.empty?
  end

  # GET /comments/1
  def show
    authorize @comment
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    authorize @comment
  end

  # GET /comments/1/edit
  def edit
    authorize @comment
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(comment_params)
    authorize @comment

    respond_to do |format|
      if @comment.save
        format.html do
          redirect_back fallback_location: root_path,
                        notice: "Comment was successfully created."
        end
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    authorize @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.html do
          redirect_to root_path,
                      notice: "Comment was successfully updated."
        end
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment
    @comment.destroy

    respond_to do |format|
      format.html do
        redirect_back fallback_location: root_path,
                      notice: "Comment was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:photo_id, :body)
  end
end
