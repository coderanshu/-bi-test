# == Schema Information
#
# Table name: observations
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  value                    :string(255)
#  patient_id               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  question_id              :integer
#  code_system              :string(255)
#  observed_on              :datetime
#  code                     :string(255)
#  units                    :string(255)
#  patient_flowsheet_row_id :integer
#

class Observation < ActiveRecord::Base
  attr_accessible :name, :value, :patient_id, :question_id, :code_system, :observed_on, :code, :units, :patient_flowsheet_row_id
  belongs_to :question
  belongs_to :patient_flowsheet_row
  belongs_to :patient
  has_many :problems

  after_save :resolve_data_dependency_status

  scope :updated_since, lambda { |last_update| where("observations.updated_at >= ? OR observations.created_at >= ?", last_update, last_update) }

  # Keep this in case we want to split apart value by type in the future.
  # attr_accessible :value_numeric, :value_text, :value_timestamp,
  #def value
  #  val = self.value_numeric.to_s
  #  val = self.value_text if val.blank?
  #  val = self.value_timestamp.strftime('%m/%d/%Y') if val.blank?
  #  val = "" if val.blank?
  #  val
  #end

  #def clear_guideline_steps
  #  guidelines = PatientGuideline.active.find_all_by_patient_id(self.patient_id)
  #  unless guidelines.blank?
  #    guidelines.each do |guideline|
  #      steps = guideline.patient_guideline_steps.needs_data
  #      next if steps.blank?
  #
  #    end
  #  end
  #end

  def updates_since? last_update
    return true unless self.updated_since(last_update).blank?
    return true unless self.problems.updated_since(last_update).blank?
    false
  end

private
  def resolve_data_dependency_status
    return if self.question_id.blank?
    question = Question.find(self.question_id)
    return if question.blank? or question.guideline_step.blank? or question.guideline_step.guideline.blank?
    # Does the question relate to any guidelines the patient is on?
    step = PatientGuidelineStep.find_by_guideline_step_id_and_patient_id(question.guideline_step_id, self.patient_id)
    return if step.blank? or !step.requires_data
    # The step requires data - does this observation complete all of the outstanding questions?
    return if step.guideline_step.questions.any?{ |q| Observation.find_by_patient_id_and_question_id(self.patient_id, q.id).nil? }
    step.update_attributes(:requires_data => false)
  end
end
