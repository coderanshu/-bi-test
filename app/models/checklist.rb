class Checklist < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :patient_checklists
  has_many :questions
end
