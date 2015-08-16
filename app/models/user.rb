class User < ActiveRecord::Base
  include ModelUtil

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :project_users, ->{where("#{ProjectUser.table_name}.deleted_at IS NULL")}
  has_many :projects, through: :project_users

  # 名前は必須
  validates_presence_of :nm, on: [:create, :update]

  # メールはユニーク(削除は除く)
  validates_uniqueness_of :email,
    conditions: -> { where("deleted_at IS NULL") }

  def email_changed?
    false
  end

  def admin?
    user_kbn == KbnConstants::USER_KBN_ADMIN
  end

  class << self
    def find_for_available
      where_for_null_at.order('id ASC').all
    end

    # 認証の時に削除は除く
    def find_first_by_auth_conditions(warden_conditions)
      where(warden_conditions).where_for_null_at.first
    end
  end
end
