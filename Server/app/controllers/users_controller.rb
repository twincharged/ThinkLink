class UsersController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create, :assemblies, :add_assembly, :homeworks]
  skip_before_action :authenticate_user!, only: [:create, :assemblies, :add_assembly, :homeworks]
  before_action :set_user, except: :create

  # GET /users/1
  def show
    respond_with @user
  end

  # GET /users/1/assemblies
  def assemblies
    respond_with @user.assemblies
  end

  # GET /users/1/homeworks
  def homeworks
    respond_with @user.homeworks
  end

  # GET /users/1/comments
  def comments
    respond_with @user.comments
  end

  # POST /users
  def create
    @user = User.new(user_params)
    code = @user.save ? 200 : 400
    respond_with status: code
  end

  def add_assembly
    assembly = Assembly.find(params[:assembly_id])
    @user.become_user_for(assembly)
    @user.become_teacher_for(assembly)
    respond_with status: 200
  end

  def answer_exam
    @user.complete_module!(:question, Unit.new(id: test_params[:exam_id]), test_params[:answers])
    render json: {status: 200}
  end

  def answer_quiz
    @user.complete_module!(:question, Chapter.new(id: test_params[:quiz_id]), test_params[:answers])
    render json: {status: 200}
  end

  # PATCH/PUT /users/1
  def update
    code = @user.update(user_params) ? 200 : 400
    respond_with status: code
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_with status: 200
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def test_params
      params[:questions][:answers] ||= [] if params.has_key?(:answers)
      params.require(:questions).permit(:quiz_id, :exam_id, answers: [])
    end
end
