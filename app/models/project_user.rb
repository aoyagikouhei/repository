class ProjectUser < ActiveRecord::Base
  include ModelUtil
  belongs_to :project
  belongs_to :user

  class << self
    def find_for_join(project_id, user_id)
      where_for_null_at.where(project_id: project_id, user_id: user_id).first
    end
  end
end
