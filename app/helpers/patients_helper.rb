module PatientsHelper
  def get_patient_problem_list_items patient
    return if patient.nil?
    patient.problems.active
  end

  def get_patient_diagnosis_list_items patient
    return if patient.nil?
    patient.problems.diagnosis
  end

  def get_potential_patient_problems patient
    return if patient.nil?
    patient.problems.possible
  end

  def get_patient_location_for_form patient
    return PatientLocation.new(:location_id => 0, :patient_id => patient.id) if patient.patient_locations.active.blank?
    return patient.patient_locations.active.last
  end
end
