# == Schema Information
#
# Table name: checklists
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Checklist < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :patient_checklists
  has_many :questions
end
