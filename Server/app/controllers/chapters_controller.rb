class ChaptersController < ApplicationController
  before_action :set_chapter, except: [:create, :index]

  # GET /chapters/1
  def show
    respond_with @chapter
  end

  # GET /chapters/1/unit
  def unit
    respond_with @chapter.unit
  end

  # GET /chapters/1/comments
  def comments
    respond_with @chapter.comments
  end

  # GET /chapters/1/questions
  def questions
    @quizAndQuestions = {quiz: @chapter, questions: @chapter.questions}
    respond_with @quizAndQuestions
  end

  # POST /chapters
  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save then respond_with @chapter
    else render json: {error: @chapter.errors}
    end
  end

  # PATCH/PUT /chapters/1
  def update
    if @chapter.update(chapter_params)
      redirect_to @chapter, notice: 'Chapter was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /chapters/1
  def destroy
    @chapter.destroy
    redirect_to chapters_url, notice: 'Chapter was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chapter_params
      params.require(:chapter).permit(:title, :content, :teacher_id, :unit_id, :quiz)
    end
end
