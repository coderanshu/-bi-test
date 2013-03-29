class Alert < ActiveRecord::Base
  has_many :alert_responses
  has_many :alert_guideline_steps
  belongs_to :body_system
  belongs_to :patient  
  attr_accessible :body_system_id, :patient_id, :alert_type, :description, :severity, :status, :acknowledged_id, :acknowledged_on, :expires_on, :action_on_expire

  scope :active, where("alerts.status = ? AND (alerts.expires_on IS NULL OR alerts.expires_on >= ?)", 1, Time.zone.now)
  scope :updated_since, lambda { |last_update| where("alerts.updated_at >= ? OR alerts.created_at >= ?", last_update, last_update) }
  scope :descending_status, order("alerts.severity DESC")
end
