class UnitsController < ApplicationController
  before_action :set_unit, except: [:create, :index]

  # GET /units/1
  def show
    respond_with @unit
  end

  # GET /units/1/teacher
  def teacher
    respond_with @unit.teacher
  end

  # GET /units/1/book
  def book
    respond_with @unit.book
  end

  # GET /units/1/users
  def users
    respond_with @unit.users
  end

  # GET /units/1/chapters
  def chapters
    respond_with @unit.chapters
  end

  # GET /units/1/questions
  def questions
    @examAndQuestions = {exam: @unit, questions: @unit.questions}
    respond_with @examAndQuestions
  end

  # POST /units
  def create
    @unit = Unit.new(unit_params)
    if @unit.save then respond_with @unit
    else render json: {error: @unit.errors}
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.update(unit_params)
      redirect_to @unit, notice: 'Unit was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /units/1
  def destroy
    @unit.destroy
    redirect_to units_url, notice: 'Unit was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def unit_params
      params.require(:unit).permit(:title, :content, :teacher_id, :book_id, :exam)
    end         
end
