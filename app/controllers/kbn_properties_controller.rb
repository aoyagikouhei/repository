class KbnPropertiesController < ApplicationController
  include ControllerUtil
  before_action :set_kbn_property, only: [:edit, :update, :destroy]
  before_action :set_project
  before_action :set_kbn


  # GET /kbn_properties/new
  def new
    @kbn_property = KbnProperty.new
  end

  # GET /kbn_properties/1/edit
  def edit
  end

  # POST /kbn_properties
  # POST /kbn_properties.json
  def create
    @kbn_property = KbnProperty.new(kbn_property_params.merge(get_create_columns).merge(
      kbn_id: @kbn.id
    ))

    respond_to do |format|
      if @kbn_property.save
        format.html { redirect_to project_kbn_path(@project, @kbn), notice: 'Kbn property was successfully created.' }
        format.json { render :show, status: :created, location: @kbn_property }
      else
        format.html { render :new }
        format.json { render json: @kbn_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kbn_properties/1
  # PATCH/PUT /kbn_properties/1.json
  def update
    respond_to do |format|
      if @kbn_property.update(kbn_property_params.merge(get_update_columns))
        format.html { redirect_to project_kbn_path(@project, @kbn), notice: 'Kbn property was successfully updated.' }
        format.json { render :show, status: :ok, location: @kbn_property }
      else
        format.html { render :edit }
        format.json { render json: @kbn_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kbn_properties/1
  # DELETE /kbn_properties/1.json
  def destroy
    @kbn_property.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_kbn_path(@project, @kbn), notice: 'Kbn property was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kbn_property
      @kbn_property = KbnProperty.find_for_available_id(params[:id])
    end

    def set_kbn
      @kbn = Kbn.find_for_available_id(params[:kbn_id])
      @breadcrumb = [
        {
          name: @kbn.logical_name,
          active: true
        }
      ]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kbn_property_params
      params.require(:kbn_property).permit(
        :logical_name,
        :physical_name,
        :code
      )
    end
end
