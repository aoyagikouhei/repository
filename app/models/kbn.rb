class Kbn < ActiveRecord::Base
  include ModelUtil
  has_many :kbn_properties, ->{where("#{KbnProperty.table_name}.deleted_at IS NULL").order("#{KbnProperty.table_name}.code ASC")}
end
