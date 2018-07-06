# coding: utf-8
require "zip"
require 'securerandom'

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
    @content = ""
    kbns = Kbn.find_for_available(@project.id)
    errs = Err.find_for_available(@project.id)
    entity_ids = params[:entity_id]
    erb = ERB.new(@temp.content)

    if entity_ids.respond_to?(:each)
      temp_zip = "#{Rails.root}/tmp/#{ SecureRandom.uuid }.zip"
      begin
        Zip::File.open(temp_zip, Zip::File::CREATE) do |zip|
          entity_ids.each do |item|
            entity = Entity.find_for_available_id(item)
            Tempfile.open("temp") do |f|
              f.puts(erb.result(binding))
              zip.add(entity.physical_name + ".sql", f)
            end
          end
        end
        send_data File.read(temp_zip),
          type: 'application/zip',
          filename: ( "#{ @temp.nm }.zip" )
      ensure
        File.unlink(temp_zip)
      end
    else
      entity = Entity.find_for_available_id(entity_ids)
      @content = erb.result(binding)
      render(layout: false) and return
    end

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
    @temp = Temp.new(temp_params.merge(get_create_columns).merge(project_id: @project.id))

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

  # コピー処理
  def copy
    # 有効なプロジェクト先か判定
    dst_project_id = params[:dst_project_id].to_i
    dst_project = @joined_projects.find{|project| project.id == dst_project_id}
    redirect_to project_temps_path(@project) if dst_project.blank?

    # 有効な区分チェック
    temps = Temp.find_for_copy(@project.id, params[:temp_id])
    temps.each do |temp|
      # コピー
      dst_temp = temp.dup
      dst_temp.project_id = params[:dst_project_id]
      dst_temp.save()
    end

    # コピー先のプロジェクトに移動
    redirect_to project_temps_path(params[:dst_project_id])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_temp
    prms = params[:temp_kbn].nil? ? params[:id] : params[:temp_kbn]
    @temp = Temp.find_for_available_id(prms)
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
