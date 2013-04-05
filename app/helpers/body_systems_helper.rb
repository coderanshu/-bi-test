module BodySystemsHelper
  def body_system_icon_path body_loc
    "#{body_loc.code}.jpg"
  end

  def body_system_alert_class patient, body_system
    return "normal" if patient.nil? or body_system.nil?
    alert = Alert.active.descending_status.find_by_patient_id_and_body_system_id(patient.id, body_system.id)
    return "normal" if alert.nil?
    return "critical" if alert.severity >= 4
    return "warning" if alert.severity == 3
    "normal"
  end

  def body_system_alert_icon patient, body_system
    return "" if patient.nil? or body_system.nil?
    return "warning.png" if any_body_system_guidelines_need_data(patient, body_system)
    alert = Alert.active.find_by_patient_id_and_body_system_id(patient.id, body_system.id)
    return "" if alert.nil?
    return "acknowledged.png" if alert.status == Alert::ACKNOWLEDGED
    ""
  end

  def any_body_system_guidelines_need_data patient, body_system
    guidelines = Guideline.find_all_by_body_system_id(body_system)
    return false if guidelines.blank?
    pat_guidelines = PatientGuideline.find(:all, :conditions => ["guideline_id IN (?)", guidelines.map{|g| g.id}])
    return false if pat_guidelines.blank?
    return pat_guidelines.any?{|g| g.patient_guideline_steps.any?{|step| step.requires_data}}
  end
end
