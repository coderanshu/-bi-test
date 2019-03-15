# == Schema Information
#
# Table name: patient_guidelines
#
#  id           :integer          not null, primary key
#  guideline_id :integer
#  patient_id   :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class PatientGuideline < ActiveRecord::Base
  belongs_to :guideline
  belongs_to :patient
  has_many :patient_guideline_steps
  has_many :patient_guideline_actions
  attr_accessible :guideline_id, :patient_id, :status

  scope :updated_since, lambda { |last_update| where("patient_guidelines.updated_at >= ? OR patient_guidelines.created_at >= ?", last_update, last_update) }

  def requires_data?
    return false if self.patient_guideline_steps.blank?
    self.patient_guideline_steps.any? {|step| step.requires_data}
  end
end
