class Observation < ActiveRecord::Base
  attr_accessible :name, :value, :patient_id, :question_id, :code_system, :observed_on, :code, :units
  belongs_to :question

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
