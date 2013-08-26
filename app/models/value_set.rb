# == Schema Information
#
# Table name: value_sets
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  code_system :string(255)
#  name        :string(255)
#  description :string(255)
#  source      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ValueSet < ActiveRecord::Base
  has_many :value_set_members

  attr_accessible :code, :code_system, :description, :name, :source
end
