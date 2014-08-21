class QuestionsController < ApplicationController
  before_action :set_question, except: [:create, :index]

  # GET /questions
  def index
    @questions = Question.all
  end

  # GET /questions/1
  def show
    respond_with @question
  end

  # GET /questions/new
  def new
    respond_with Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    if @question.save then respond_with @question
    else render json: {error: @question.errors}
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:content, :a, :b, :c, :d, :answer, :unit_id, :chapter_id)
    end
end
