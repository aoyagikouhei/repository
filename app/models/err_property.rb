class ErrProperty < ActiveRecord::Base
  include ModelUtil

  validates :logical_name, presence: true
  validates :physical_name, presence: true
  validates :code, presence: true
end
