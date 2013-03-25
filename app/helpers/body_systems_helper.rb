module BodySystemsHelper
  def body_system_icon_path body_loc
    "#{body_loc.code}.jpg"
  end

  def body_system_alert_class patient, body_system
    return "normal" if patient.nil? or body_system.nil?
    alert = Alert.active.find_by_patient_id_and_body_system_id(patient.id, body_system.id)
    return "normal" if alert.nil?
    return "critical" if alert.severity >= 4
    return "warning" if alert.severity == 3
    "normal"
  end

  def body_system_alert_icon patient, body_system
    return "" if patient.nil? or body_system.nil?
    alert = Alert.find_by_patient_id_and_body_system_id(patient.id, body_system.id)
    return "" if alert.nil?
    return "acknowledged.png" unless alert.acknowledged_on.blank?
    ""
  end
end
