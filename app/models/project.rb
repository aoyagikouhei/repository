class Project < ActiveRecord::Base
  include ModelUtil
  has_many :project_users, ->{where("#{ProjectUser.table_name}.deleted_at IS NULL")}
  has_many :users, through: :project_users
  has_many :erds, ->{where("#{Erd.table_name}.deleted_at IS NULL")}
  after_save :join_project

  attr_accessor :join_user_id, :admin_user_id

  class << self
    # 参加しているプロジェクトを取得する
    def find_for_join(user_id, project_id: nil)
      sql = <<-EOS
        SELECT
          t1.*
        FROM
          projects AS t1
        WHERE
          t1.deleted_at IS NULL
          AND EXISTS (
            SELECT
              1
            FROM
              project_users AS t2
            WHERE
              t1.id = t2.project_id
              AND t2.deleted_at IS NULL
              AND t2.user_id = :user_id
          )
      EOS
      db_params = { user_id: user_id }
      if project_id.present? && project_id.to_i > 0
        # プロジェクトIDがある場合は1件に絞る
        sql += " AND t1.id = :project_id "
        db_params.merge!(project_id: project_id)
        find_by_sql([sql, db_params]).first
      else
        find_by_sql([sql, db_params])
      end
    end
  end

  private
  # プロジェクトメンバーを更新する
  def join_project
    # 削除の時は発動しない
    if join_user_id.blank? && admin_user_id.blank?
      return
    end
    delete_prms = {
      deleted_at: updated_at,
      deleted_id: updated_id,
      deleted_pg: updated_pg,
    }
    update_prms = {
      updated_at: updated_at,
      updated_id: updated_id,
      updated_pg: updated_pg,
    }
    create_prms = {
      created_at: updated_at,
      created_id: updated_id,
      created_pg: updated_pg,
    }.merge(update_prms)

    # 削除処理
    project_users.each do |project_user|
      if !join_user_id.include?(project_user.user_id.to_s)
        project_user.assign_attributes(delete_prms)
        project_user.save()
      end
    end

    join_user_id.each do |user_id|
      admin_flag = admin_user_id.include?(user_id.to_s)
      pu = ProjectUser.find_for_join(id, user_id)
      if pu.blank?
        # 新規
        pu = ProjectUser.new({
          project_id: id,
          user_id: user_id,
          admin_flag: admin_flag
        }.merge(create_prms))
        pu.save()
      elsif pu.admin_flag != admin_flag
        pu.assign_attributes({
          admin_flag: admin_flag
        }.merge(update_prms))
        pu.save()
      end
    end
  end

end
