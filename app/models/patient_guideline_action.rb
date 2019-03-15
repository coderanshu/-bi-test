# == Schema Information
#
# Table name: patient_guideline_actions
#
#  id                   :integer          not null, primary key
#  patient_id           :integer
#  guideline_action_id  :integer
#  patient_guideline_id :integer
#  acted_id             :integer
#  acted_on             :datetime
#  action               :string(255)
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  details              :text
#

class PatientGuidelineAction < ActiveRecord::Base
  belongs_to :patient
  belongs_to :patient_guideline
  belongs_to :guideline_action
  attr_accessible :acted_id, :acted_on, :action, :guideline_action_id, :patient_guideline_id, :patient_id, :status, :details

  scope :updated_since, lambda { |last_update| where("patient_guideline_actions.updated_at >= ? OR patient_guideline_actions.created_at >= ?", last_update, last_update) }
end
