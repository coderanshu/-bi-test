# == Schema Information
#
# Table name: value_set_members
#
#  id           :integer          not null, primary key
#  value_set_id :integer
#  code         :string(255)
#  name         :string(255)
#  description  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ValueSetMember < ActiveRecord::Base
  belongs_to :value_set

  attr_accessible :value_set_id, :code, :description, :name
end
