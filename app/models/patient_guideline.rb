class PatientGuideline < ActiveRecord::Base
  belongs_to :guideline
  belongs_to :patient
  has_many :patient_guideline_steps
  attr_accessible :guideline_id, :patient_id, :status
end
