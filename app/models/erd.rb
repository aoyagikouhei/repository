class Erd < ActiveRecord::Base
  include ModelUtil
  has_many :entities, dependent: :destroy
end
