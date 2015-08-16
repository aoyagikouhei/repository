class Temp < ActiveRecord::Base
  include ModelUtil

  class << self
    def find_for_available
      where_for_null_at.order('temp_kbn ASC')
    end

    def find_for_output(value)
      where_for_null_at.where('temp_kbn = ?' ,value)
    end
  end
end
