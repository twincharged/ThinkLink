class HomeworksController < ApplicationController
  before_action :set_homework, except: :create

  # GET /homeworks/1
  def show
    respond_with @homework
  end

  # GET /homeworks/1/user
  def user
    respond_with @homework.user
  end

  # GET /homeworks/1/book
  def book
    respond_with @homework.book
  end

  # POST /homeworks
  def create
    @homework = Homework.new(homework_params)
    code = @homework.save ? 200 : 400
    respond_with status: code
  end

  # PATCH/PUT /homeworks/1
  def update
    code = @homework.update(homework_params) ? 200 : 400
    respond_with status: code
  end

  # DELETE /homeworks/1
  def destroy
    @homework.destroy
    respond_with status: 200
  end

  private
    def set_homework
      @homework = Homework.find(params[:id])
    end

    def homework_params
      params[:homework]
    end
end
