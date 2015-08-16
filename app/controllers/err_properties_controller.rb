class ErrPropertiesController < ApplicationController
  include ControllerUtil
  before_action :set_err_property, only: [:edit, :update, :destroy]
  before_action :set_project
  before_action :set_err

  # GET /err_properties/new
  def new
    @err_property = ErrProperty.new
  end

  # GET /err_properties/1/edit
  def edit
  end

  # POST /err_properties
  # POST /err_properties.json
  def create
    @err_property = ErrProperty.new(err_property_params.merge(get_create_columns).merge(
      err_id: @err.id
    ))

    respond_to do |format|
      if @err_property.save
        format.html { redirect_to project_err_path(@project, @err), notice: 'Err property was successfully created.' }
        format.json { render :show, status: :created, location: @err_property }
      else
        format.html { render :new }
        format.json { render json: @err_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /err_properties/1
  # PATCH/PUT /err_properties/1.json
  def update
    respond_to do |format|
      if @err_property.update(err_property_params.merge(get_update_columns))
        format.html { redirect_to project_err_path(@project, @err), notice: 'Err property was successfully updated.' }
        format.json { render :show, status: :ok, location: @err_property }
      else
        format.html { render :edit }
        format.json { render json: @err_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /err_properties/1
  # DELETE /err_properties/1.json
  def destroy
    @err_property.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_err_path(@project, @err), notice: 'Err property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_err_property
      @err_property = ErrProperty.find_for_available_id(params[:id])
    end

    def set_err
      @err = Err.find_for_available_id(params[:err_id])
      @breadcrumb = [
        {
          name: @err.logical_name,
          active: true
        }
      ]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def err_property_params
      params.require(:err_property).permit(
        :logical_name,
        :physical_name,
        :code,
        :db_code,
        :message_content,
        :warning_flag,
      )
    end
end
