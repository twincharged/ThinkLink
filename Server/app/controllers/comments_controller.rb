class CommentsController < ApplicationController
  before_action :set_comment, except: [:create, :index]

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show
    respond_with @comment
  end

  # GET /comments/1/user
  def user
    respond_with @comment.user
  end

  # GET /comments/1/chapter
  def chapter
    respond_with @comment.chapter
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      redirect_to @comment, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params[:comment]
    end
end
