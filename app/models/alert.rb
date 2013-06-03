class Alert < ActiveRecord::Base
  ACTIVE = 1
  ACKNOWLEDGED = 2
  DEFERRED = 3
  MARKED_INCORRECT = 4
  RESOLVED = 5
  ADD_TO_DX_LIST = 6

  has_many :alert_responses
  has_many :alert_guideline_steps
  belongs_to :body_system
  belongs_to :patient
  belongs_to :guideline
  attr_accessible :body_system_id, :patient_id, :alert_type, :description, :severity, :status, :acknowledged_id, :acknowledged_on, :expires_on, :action_on_expire, :guideline_id

  scope :active, where("alerts.status IN (?, ?, ?) AND (alerts.expires_on IS NULL OR alerts.expires_on >= ?)", ACTIVE, DEFERRED, ACKNOWLEDGED, Time.zone.now)
  scope :updated_since, lambda { |last_update| where("alerts.updated_at >= ? OR alerts.created_at >= ?", last_update, last_update) }
  scope :descending_status, order("alerts.severity DESC")
end
