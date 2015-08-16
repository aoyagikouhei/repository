class Err < ActiveRecord::Base
  include ModelUtil
  has_many :err_properties, ->{
    where("#{ErrProperty.table_name}.deleted_at IS NULL").
    order("#{ErrProperty.table_name}.code ASC")
  }
end
