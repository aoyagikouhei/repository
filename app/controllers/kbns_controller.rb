class KbnsController < ApplicationController
  include ControllerUtil
  before_action :set_kbn, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /kbns
  # GET /kbns.json
  def index
    @temps = Temp.find_for_output(@project.id, KbnConstants::TEMP_KBN_KBN)
    @kbns = Kbn.find_for_available(@project.id)
  end

  # GET /kbns/1
  # GET /kbns/1.json
  def show
    @breadcrumb = [{
      name: @kbn.logical_name,
      active: true
    }]
  end

  # GET /kbns/new
  def new
    @kbn = Kbn.new
  end

  # GET /kbns/1/edit
  def edit
  end

  # POST /kbns
  # POST /kbns.json
  def create
    @kbn = Kbn.new(kbn_params.merge(get_create_columns).merge(
      project_id: @project.id
    ))

    respond_to do |format|
      if @kbn.save
        format.html { redirect_to project_kbns_path(@project), notice: 'Kbn was successfully created.' }
        format.json { render :show, status: :created, location: @kbn }
      else
        format.html { render :new }
        format.json { render json: @kbn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kbns/1
  # PATCH/PUT /kbns/1.json
  def update
    respond_to do |format|
      if @kbn.update(kbn_params.merge(get_update_columns))
        format.html { redirect_to project_kbns_path(@project), notice: 'Kbn was successfully updated.' }
        format.json { render :show, status: :ok, location: @kbn }
      else
        format.html { render :edit }
        format.json { render json: @kbn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kbns/1
  # DELETE /kbns/1.json
  def destroy
    @kbn.update(get_delete_columns)
    respond_to do |format|
      format.html { redirect_to project_kbns_path(@project), notice: 'Kbn was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kbn
      @kbn = Kbn.find_for_available_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kbn_params
      params.require(:kbn).permit(
        :logical_name,
        :physical_name,
        :code
      )
    end
end
