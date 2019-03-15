# == Schema Information
#
# Table name: patient_checklists
#
#  id           :integer          not null, primary key
#  checklist_id :integer
#  patient_id   :integer
#  date         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class PatientChecklist < ActiveRecord::Base
  attr_accessible :checklist_id, :patient_id, :date
  belongs_to :patient
  belongs_to :checklist
  has_many :observations
end
