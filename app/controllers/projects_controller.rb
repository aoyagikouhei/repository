class ProjectsController < ApplicationController
  include ControllerUtil
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit]

  # GET /projects
  # GET /projects.json
  def index
    @models = Project.find_for_available
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = @model
  end

  # GET /projects/new
  def new
    @model = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @model = Project.new(project_params.merge(get_create_columns))

    respond_to do |format|
      if @model.save
        format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { render :new }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @model.update(project_params.merge(get_update_columns))
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @model.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @model = Project.find_for_available_id(params[:id])
    end

    def set_users
      @users = User.find_for_available
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :nm,
        join_user_id: [],
        admin_user_id: [],
      )
    end
end
