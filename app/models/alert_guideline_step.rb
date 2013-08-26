# == Schema Information
#
# Table name: alert_guideline_steps
#
#  id                        :integer          not null, primary key
#  alert_id                  :integer
#  patient_guideline_step_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class AlertGuidelineStep < ActiveRecord::Base
  belongs_to :alert
  belongs_to :patient_guideline_step

  attr_accessible :alert_id, :patient_guideline_step_id
end
