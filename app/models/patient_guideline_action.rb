class PatientGuidelineAction < ActiveRecord::Base
  belongs_to :patient
  belongs_to :patient_guideline
  belongs_to :guideline_action
  attr_accessible :acted_id, :acted_on, :action, :guideline_action_id, :patient_guideline_id, :patient_id, :status

  scope :updated_since, lambda { |last_update| where("patient_guideline_actions.updated_at >= ? OR patient_guideline_actions.created_at >= ?", last_update, last_update) }
end
