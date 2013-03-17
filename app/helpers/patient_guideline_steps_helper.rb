module PatientGuidelineStepsHelper
  def fill_in_step_details patient, text
    observations = Observation.find_all_by_patient_id(patient.id)
    observations.each do |obs|
      text = text.gsub("[[#{obs.name}]]", obs.value)    
    end
    text
  end
end
