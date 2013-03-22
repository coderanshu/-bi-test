class ValueSetMember < ActiveRecord::Base
  belongs_to :value_set

  attr_accessible :value_set_id, :code, :description, :name
end
