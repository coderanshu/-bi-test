# == Schema Information
#
# Table name: patient_guideline_steps
#
#  id                   :integer          not null, primary key
#  patient_guideline_id :integer
#  guideline_step_id    :integer
#  is_met               :boolean
#  requires_data        :boolean
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  patient_id           :integer
#

class PatientGuidelineStep < ActiveRecord::Base
  belongs_to :patient_guideline
  belongs_to :guideline_step
  has_many :questions, :through => :guideline_step
  has_many :guideline_step_observations
  attr_accessible :guideline_step_id, :is_met, :patient_guideline_id, :requires_data, :status, :patient_id

  scope :updated_since, lambda { |last_update| where("patient_guideline_steps.updated_at >= ? OR patient_guideline_steps.created_at >= ?", last_update, last_update) }
  #scope :needs_data, where("patient_guideline_steps.requires_data = true AND patient_guideline_steps.is_met = false")
end
