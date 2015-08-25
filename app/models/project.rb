class Project < ActiveRecord::Base
  include ModelUtil
  has_many :project_users, ->{where("#{ProjectUser.table_name}.deleted_at IS NULL")}
  has_many :users, through: :project_users
  has_many :erds, ->{where("#{Erd.table_name}.deleted_at IS NULL")}
  after_save :join_project

  attr_accessor :join_user_id, :admin_user_id

  validates :logical_name, presence: true
  validates :physical_name, presence: true, uniqueness: { conditions: -> { where("deleted_at IS NULL") } }

  class << self
    # プロジェクト一覧を取得する。参加しているかどうかわかる。
    def find_for_with_join(user_id)
      sql = <<-EOS
        SELECT
          t1.*
          ,STRING_AGG(CASE WHEN t2.admin_flag THEN t3.nm ELSE NULL END, ',') AS admins
          ,bool_or(t2.user_id = :user_id) AS join_flag
          ,bool_or(t2.admin_flag = TRUE AND t2.user_id = :user_id) AS admin_flag
        FROM
          projects AS t1
          INNER JOIN project_users AS t2 ON (
            t1.id = t2.project_id
            AND t2.deleted_at IS NULL
          )
          INNER JOIN users AS t3 ON (
            t2.user_id = t3.id
            AND t3.deleted_at IS NULL
          )
        WHERE
          t1.deleted_at IS NULL
        GROUP BY
          t1.id
      EOS
      db_params = { user_id: user_id }
      find_by_sql([sql, db_params])
    end

    # 参加しているプロジェクトを取得する
    def find_for_join(user_id, project_id: nil, except_project_id: nil)
      sql = <<-EOS
        SELECT
          t1.*
          ,t2.admin_flag
        FROM
          projects AS t1
          INNER JOIN project_users AS t2 ON (
            t1.id = t2.project_id
            AND t2.deleted_at IS NULL
            AND t2.user_id = :user_id
          )
        WHERE
          t1.deleted_at IS NULL
      EOS
      db_params = { user_id: user_id }
      if except_project_id.present? && except_project_id.to_i > 0
        sql += " AND t1.id <> :except_project_id "
        db_params[:except_project_id] = except_project_id
      end
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
