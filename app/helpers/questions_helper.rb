module QuestionsHelper
  def answer_partial question
    "questions/question_#{question.question_type}"
  end

  def get_value_set_members question
    value_set = ValueSet.find_by_code(question.constraints) unless question.blank?
    value_set.value_set_members unless value_set.blank?
  end

  def get_question_observation question, patient
    return nil if question.blank? or patient.blank?
    Observation.find_by_patient_id_and_question_id(patient.id, question.id)
  end
end
