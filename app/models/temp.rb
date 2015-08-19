class Temp < ActiveRecord::Base
  include ModelUtil

  class << self
    def find_for_available(project_id)
      where_for_null_at.where(project_id: project_id).order('temp_kbn ASC')
    end

    def find_for_output(value)
      where_for_null_at.where('temp_kbn = ?' ,value)
    end
  end
end
