class Kbn < ActiveRecord::Base
  include ModelUtil
  has_many :kbn_properties, ->{where("#{KbnProperty.table_name}.deleted_at IS NULL").order("#{KbnProperty.table_name}.code ASC")}

  validates :logical_name, presence: true
  validates :physical_name, presence: true
  validates :code, presence: true

  class << self
    def find_for_available(project_id)
      where_for_null_at.where(project_id: project_id).order('code ASC').all
    end

    def find_for_copy(project_id, kbn_id_array)
      where_for_null_at.where(project_id: project_id).where("id = ANY(?)", make_id_array(kbn_id_array))
    end
  end
end
