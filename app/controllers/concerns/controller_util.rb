module ControllerUtil extend ActiveSupport::Concern
  # 新規登録用のカラムを取得する
  def get_create_columns(pg: nil)
    pg = "#{controller_name}#create" if pg.blank?
    get_update_columns(pg: pg).merge({
      created_id: current_user.id,
      created_pg: pg,
    })
  end

  # 更新用のカラムを取得する
  def get_update_columns(pg: nil)
    pg = "#{controller_name}#update" if pg.blank?
    {
      updated_id: current_user.id,
      updated_pg: pg,
    }
  end

  # 削除用のカラムを取得する
  def get_delete_columns(pg: nil)
    pg = "#{controller_name}#delete" if pg.blank?
    {
      deleted_id: current_user.id,
      deleted_pg: pg,
      deleted_at: Time.now,
    }
  end

  def set_project(project_id: nil)
    project_id = params[:project_id] if project_id.blank?
    @project = Project.find_for_join(current_user.id, project_id: project_id)
    redirect_to projects_url if @project.blank?
  end

  def set_erd(erd_id: nil)
    erd_id = params[:erd_id] if erd_id.blank?
    @erd = Erd.find_for_available_id(erd_id)
  end
end
