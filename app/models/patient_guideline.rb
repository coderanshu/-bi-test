class PatientGuideline < ActiveRecord::Base
  belongs_to :guideline
  belongs_to :patient
  has_many :patient_guideline_steps
  attr_accessible :guideline_id, :patient_id, :status

  scope :updated_since, lambda { |last_update| where("patient_guidelines.updated_at >= ? OR patient_guidelines.created_at >= ?", last_update, last_update) }
end
