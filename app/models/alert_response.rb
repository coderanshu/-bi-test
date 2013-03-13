class AlertResponse < ActiveRecord::Base
  belongs_to :alert
  attr_accessible :alert_id, :response_type, :user_id
end
