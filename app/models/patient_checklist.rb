class PatientChecklist < ActiveRecord::Base
  attr_accessible :checklist_id, :patient_id, :date
  belongs_to :patient
  belongs_to :checklist
  has_many :observations
end
