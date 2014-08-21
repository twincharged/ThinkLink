class AssembliesController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: :create
  skip_before_action :authenticate_user!, only: :create
  before_action :set_assembly, except: [:create, :index]

  # GET /assemblies
  def index
    @assemblies = Assembly.all
  end

  # GET /assemblies/1
  def show
    respond_with @assembly
  end

  # GET /assemblies/1/teachers
  def teachers
    respond_with @assembly.teachers
  end

  # GET /assemblies/1/teachers
  def teacher_ids
    respond_with @assembly.rsmembs(:teacher_ids).map(&:to_i)
  end

  # GET /assemblies/1/users
  def users
    respond_with @assembly.users
  end

  # GET /assemblies/1/books
  def books
    respond_with @assembly.books
  end

  # GET /assemblies/new
  def new
    respond_with Assembly.new
  end

  # GET /assemblies/1/edit
  def edit
  end

  # POST /assemblies
  def create
    @assembly = Assembly.new(assembly_params)
    if @assembly.save
      respond_with @assembly
    else
      render json: {error: @assembly.errors}
    end
  end

  # PATCH/PUT /assemblies/1
  def update
    if @assembly.update(assembly_params)
      redirect_to @assembly, notice: 'Assembly was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /assemblies/1
  def destroy
    @assembly.destroy
    redirect_to assemblies_url, notice: 'Assembly was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assembly
      @assembly = Assembly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def assembly_params
      params.require(:assembly).permit(:name)
    end
end
