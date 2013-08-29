class Problem < ActiveRecord::Base
  belongs_to :observation
  attr_accessible :observation_id, :status, :alert_id
  
  scope :active, where("problems.status = ?", 'Active')
  scope :possible, where("problems.status = ?", 'Possible')
end
