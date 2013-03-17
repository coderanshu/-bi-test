module AlertsHelper
  def alert_css_class alert
    return "critical" if alert.severity >= 4
    return "warning" if alert.severity == 3
    ""
  end
end
