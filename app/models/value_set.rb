class ValueSet < ActiveRecord::Base
  has_many :value_set_members

  attr_accessible :code, :code_system, :description, :name, :source
end
