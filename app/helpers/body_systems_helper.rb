module BodySystemsHelper
  def body_system_icon_path body_loc
    "#{body_loc.code}.jpg"
  end

  def body_system_alert_class patient, body_system
    return "" if patient.nil? or body_system.nil?
    alert = Alert.find_by_patient_id_and_body_system_id(patient.id, body_system.id)
    return "" if alert.nil?
    "critical"
  end
end
