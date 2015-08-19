class ErrsController < ApplicationController
  include ControllerUtil
  before_action :set_err, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /errs
  # GET /errs.json
  def index
    @temps = Temp.find_for_output(@project.id, KbnConstants::TEMP_KBN_ERROR)
    @errs = Err.find_for_available(@project.id)
  end

  # GET /errs/1
  # GET /errs/1.json
  def show
    @breadcrumb = [{
      name: @err.logical_name,
      active: true
    }]
  end

  # GET /errs/new
  def new
    @err = Err.new
  end

  # GET /errs/1/edit
  def edit
  end

  # POST /errs
  # POST /errs.json
  def create
    @err = Err.new(err_params.merge(get_create_columns).merge(
      project_id: @project.id
    ))

    respond_to do |format|
      if @err.save
        format.html { redirect_to project_errs_path(@project), notice: 'Err was successfully created.' }
        format.json { render :show, status: :created, location: @err }
      else
        format.html { render :new }
        format.json { render json: @err.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /errs/1
  # PATCH/PUT /errs/1.json
  def update
    respond_to do |format|
      if @err.update(err_params.merge(get_update_columns))
        format.html { redirect_to project_errs_path(@project), notice: 'Err was successfully updated.' }
        format.json { render :show, status: :ok, location: @err }
      else
        format.html { render :edit }
        format.json { render json: @err.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /errs/1
  # DELETE /errs/1.json
  def destroy
    @err.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_errs_path(@project), notice: 'Err was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_err
      @err = Err.find_for_available_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def err_params
      params.require(:err).permit(
        :logical_name,
        :physical_name,
        :code
      )
    end
end
