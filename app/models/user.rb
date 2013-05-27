class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :edit, :email, :new, :password, :username, :password_confirmation, :persistence_token, :display_name
end
