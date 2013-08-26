# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  username           :string(255)
#  name               :string(255)
#  email              :string(255)
#  workphone          :string(255)
#  cellphone          :string(255)
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)
#  login_count        :integer
#  failed_login_count :integer
#  current_login_at   :string(255)
#  last_login_at      :string(255)
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  display_name       :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :edit, :email, :new, :password, :username, :password_confirmation, :persistence_token, :display_name
end
