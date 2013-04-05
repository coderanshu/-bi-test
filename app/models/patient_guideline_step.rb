class PatientGuidelineStep < ActiveRecord::Base
  belongs_to :patient_guideline
  belongs_to :guideline_step
  has_many :questions, :through => :guideline_step
  attr_accessible :guideline_step_id, :is_met, :patient_guideline_id, :requires_data, :status

  scope :updated_since, lambda { |last_update| where("patient_guideline_steps.updated_at >= ? OR patient_guideline_steps.created_at >= ?", last_update, last_update) }
end
