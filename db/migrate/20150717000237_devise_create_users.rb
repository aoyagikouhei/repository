class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users, id: false) do |t|
      t.column :id, 'BIGSERIAL PRIMARY KEY'

      ## Database authenticatable
      t.text :email,              null: false, default: ""
      t.text :encrypted_password, null: false, default: ""

      ## Recoverable
      t.text   :reset_password_token
      t.column :reset_password_sent_at, 'TIMESTAMPTZ'

      ## Rememberable
      t.column :remember_created_at, 'TIMESTAMPTZ'

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.column :current_sign_in_at, 'TIMESTAMPTZ'
      t.column :last_sign_in_at, 'TIMESTAMPTZ'
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      
      t.column :nm, 'TEXT', null: false, default: ''
      t.column :user_kbn, 'TEXT', null: false, default: ''

      t.column :created_id, 'BIGINT', null: false, default: 0
      t.column :updated_id, 'BIGINT', null: false, default: 0
      t.column :deleted_id, 'BIGINT', null: false, default: 0

      t.text :created_pg, null: false, default: ''
      t.text :updated_pg, null: false, default: ''
      t.text :deleted_pg, null: false, default: ''

      t.column :created_at, 'TIMESTAMPTZ', null: false
      t.column :updated_at, 'TIMESTAMPTZ', null: false
      t.column :deleted_at, 'TIMESTAMPTZ'

      t.text :bk
    end

    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end

