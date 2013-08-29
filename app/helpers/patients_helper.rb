module PatientsHelper
  def get_patient_problem_list_items patient
    return if patient.nil?
    patient.problems.active
  end
  
  def get_potential_patient_problems patient
    return if patient.nil?
    patient.problems.possible
  end
end
