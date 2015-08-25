class ProjectUser < ActiveRecord::Base
  include ModelUtil
  belongs_to :project
  belongs_to :user

  class << self
    def find_for_join(project_id, user_id)
      where_for_null_at.where(project_id: project_id, user_id: user_id).first
    end

    def find_for_project_users(project_id)
      #ProjectUser.joins(:user).where("#{User.table_name}.deleted_at IS NULL AND #{ProjectUser.table_name}.deleted_at IS NULL AND #{ProjectUser.table_name}.project_id = ?", project_id).select("#{ProjectUser.table_name}.admin_flag, #{User.table_name}.nm")
      sql = <<-EOS
        SELECT
          t1.admin_flag
          ,t2.nm
        FROM
          project_users AS t1
          INNER JOIN users AS t2 ON (
            t1.user_id = t2.id
          )
        WHERE
          t1.deleted_at IS NULL
          AND t2.deleted_at IS NULL
          AND t1.project_id = :project_id
      EOS
      find_by_sql([sql, {project_id: project_id}])
    end
  end
end
