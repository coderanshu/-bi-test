class CreateUsers < ActiveRecord::Migration
  def change
    create_table "users", :force => true do |t|
      t.integer :user_id
      t.string :username
      t.string :name
      t.string :email
      t.string :workphone
      t.string :cellphone
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.integer :failed_login_count
      t.string :current_login_at
      t.string :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.timestamps
    end
  end
end
