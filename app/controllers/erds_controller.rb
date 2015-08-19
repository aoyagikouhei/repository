require 'rober/reader'
class ErdsController < ApplicationController
  include ControllerUtil
  before_action :set_erd, only: [:show, :edit, :update, :destroy, :upload, :entity]
  before_action :set_project

  # GET /erds
  # GET /erds.json
  def index
    @erds = Erd.find_for_available(@project.id)
  end

  # GET /erds/1
  # GET /erds/1.json
  def show
    @breadcrumb = [{
      name: @erd.nm,
      active: true
    }]
  end

  # GET /erds/new
  def new
    @erd = Erd.new
  end

  # GET /erds/1/edit
  def edit
  end

  # POST /erds
  # POST /erds.json
  def create
    @erd = Erd.new(erd_params.merge(get_create_columns).merge(
      project_id: @project.id
    ))

    respond_to do |format|
      if @erd.save
        format.html { redirect_to project_erd_path(@project, @erd), notice: 'Erd was successfully created.' }
        format.json { render :show, status: :created, location: @erd }
      else
        format.html { render :new }
        format.json { render json: @erd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /erds/1
  # PATCH/PUT /erds/1.json
  def update
    respond_to do |format|
      if @erd.update(erd_params.merge(get_update_columns))
        format.html { redirect_to project_erd_path(@project, @erd), notice: 'Erd was successfully updated.' }
        format.json { render :show, status: :ok, location: @erd }
      else
        format.html { render :edit }
        format.json { render json: @erd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /erds/1
  # DELETE /erds/1.json
  def destroy
    @erd.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_erds_path(@project), notice: 'Erd was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # ERDファイルのアップロード
  def upload
    result = Rober::Reader.read(params[:file].path)
    Entity.destroy_all(["erd_id = ?", @erd.id])
    result[:entities].each do |src|
      entity = Entity.new({
        logical_name: src.logical_name, 
        physical_name: src.physical_name, 
        comment: src.comment, 
        erd_id: @erd.id
      })
      entity.save()
      src.attributes.each do |attr|
        #Rails.logger.debug(attr)
        property = Property.new({
          entity_id: entity.id,
          logical_name: attr.logical_name,
          physical_name: attr.physical_name,
          comment: attr.comment.nil? ? '' : attr.comment,
          datatype: attr.datatype,
          default_content: attr.def,
          length: attr.length,
          scale: attr.scale,
          null_flag: attr.null,
          pk_flag: attr.pk,
        })
        property.save()
      end
    end
    redirect_to project_erd_path(@project, @erd)
  end

  def entity
    @temps = Temp.find_for_output(@project.id, KbnConstants::TEMP_KBN_TABLE)
    @entity = Entity.find_for_available_id(params[:id])
    @breadcrumb = [
      {
        name: @erd.nm,
        url: project_erd_path(@project, @erd)
      },
      {
        name: "#{@entity.logical_name}(#{ @entity.physical_name})",
        active: true
      }
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_erd
      erd_id = params[:erd_id]
      erd_id = params[:id] if erd_id.blank?
      @erd = Erd.find_for_available_id(erd_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def erd_params
      params.require(:erd).permit(
        :nm,
        :content
      )
    end
end
