class Alert < ActiveRecord::Base
  has_many :alert_responses
  belongs_to :body_system
  belongs_to :patient
  attr_accessible :body_system_id, :patient_id, :alert_type, :description, :severity
end
