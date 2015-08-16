class Entity < ActiveRecord::Base
  include ModelUtil
  belongs_to :erd
  has_many :properties, dependent: :delete_all
end
