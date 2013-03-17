class PatientGuidelineStep < ActiveRecord::Base
  belongs_to :patient_guideline
  belongs_to :guideline_step
  attr_accessible :guideline_step_id, :is_met, :patient_guideline_id, :requires_data, :status
end
