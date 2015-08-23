class Temp < ActiveRecord::Base
  include ModelUtil

  validates :nm, presence: true

  class << self
    def find_for_available(project_id)
      where_for_null_at.where(project_id: project_id).order('temp_kbn ASC').all
    end

    def find_for_output(project_id, value)
      where_for_null_at.where(temp_kbn: value, project_id: project_id).all
    end
  end
end
