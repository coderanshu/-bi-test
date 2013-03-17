class AlertGuidelineStep < ActiveRecord::Base
  belongs_to :alert
  belongs_to :patient_guideline_step

  attr_accessible :alert_id, :patient_guideline_step_id
end
