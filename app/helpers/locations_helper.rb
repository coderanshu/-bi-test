module LocationsHelper
  def location_header location
    return "(Unknown)" if location.nil?
    if location.can_have_patients and !location.patient_locations.active.blank?
      return "<span class='name'>#{location.assigned_patient.name}</span><span class='demographics'></span>"
    end
    location.name
  end

  def patient_location_score location
    return -1 if location.assigned_patient.blank?
    patient = location.assigned_patient
    total = 0
    patient.alerts.active.each { |alert| total = total + alert.severity }
    total
  end

  def unit_location_summary location
    children = Location.find_all_by_parent_id(location.id)
    summary = {:patient_count => 0, :status_class => "normal", :critical_count => 0, :warning_count => 0 }
    children.each do |loc|
      next if loc.patient_locations.active.blank?
      summary[:patient_count] = summary[:patient_count] + 1
      patient = loc.patient_locations.active.first.patient
      has_critical = false
      has_warning = false
      @body_systems.each do |body_loc|
        alert_class = body_system_alert_class(patient, body_loc)
        has_critical = true if alert_class == "critical"
        has_warning = true if alert_class == "warning"
        break if has_critical
      end
      summary[:critical_count] = summary[:critical_count] + 1 if has_critical
      summary[:warning_count] = summary[:warning_count] + 1 if has_warning
      #break if has_critical
    end

    summary[:status_class] = (summary[:critical_count] > 0) ? "critical" : ((summary[:warning_count] > 0) ? "warning" : "normal")
    summary
  end

  def current_context_image(context_body_system, context_view)
    return view_icon_path(context_view) unless context_view.blank?
    body_system_icon_path(context_body_system)
  end

  def current_context_alert_class(patient, context_body_system, context_view)
    return view_alert_class(patient, context_view) unless context_view.blank?
    body_system_alert_class(patient, context_body_system)
  end

  def current_context_title(context_body_system, context_view)
    return context_view.titleize unless context_view.blank?
    context_body_system.name
  end

  def view_icon_path view
    "#{view}.jpg"
  end

  def view_alert_class patient, view
    "normal"
  end

  def view_alert_icon patient, view
    ""
  end
end
