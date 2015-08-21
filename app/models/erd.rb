class Erd < ActiveRecord::Base
  include ModelUtil
  has_many :entities, dependent: :destroy

  validates :nm, presence: true

  class << self
    def find_for_available(project_id)
      where_for_null_at.where(project_id: project_id).all
    end
  end
end
