class TempsController < ApplicationController
  include ControllerUtil
  before_action :set_temp, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /temps
  # GET /temps.json
  def index
    @temps = Temp.find_for_available(@project.id)
  end

  def show
    kbns = Kbn.find_for_available(@project.id)
    entity = Entity.find_for_available_id(params[:entity_id]) if params[:entity_id].present?
    erb = ERB.new(@temp.content)
    @content = erb.result(binding)
    render layout: false
  end

  # GET /temps/new
  def new
    @temp = Temp.new
  end

  # GET /temps/1/edit
  def edit
  end

  # POST /temps
  # POST /temps.json
  def create
    @temp = Temp.new(temp_params.merge(get_create_columns).merge(
      project_id: @project.id
    ))

    respond_to do |format|
      if @temp.save
        format.html { redirect_to project_temps_path(@project), notice: 'Temp was successfully created.' }
        format.json { render :show, status: :created, location: @temp }
      else
        format.html { render :new }
        format.json { render json: @temp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /temps/1
  # PATCH/PUT /temps/1.json
  def update
    respond_to do |format|
      if @temp.update(temp_params.merge(get_update_columns))
        format.html { redirect_to edit_project_temp_path(@project, @temp), notice: 'Temp was successfully updated.' }
        format.json { render :show, status: :ok, location: @temp }
      else
        format.html { render :edit }
        format.json { render json: @temp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temps/1
  # DELETE /temps/1.json
  def destroy
    @temp.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_temps_path(@project), notice: 'Temp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp
      @temp = Temp.find_for_available_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def temp_params
      params.require(:temp).permit(
        :nm,
        :temp_kbn,
        :content
      )
    end
end
