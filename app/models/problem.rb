class Problem < ActiveRecord::Base
  belongs_to :observation
  belongs_to :alert
  attr_accessible :observation_id, :status, :alert_id

  scope :active, where("problems.status = ?", 'Active')
  scope :possible, where("problems.status = ?", 'Possible')
  scope :diagnosis, where("problems.status = ?", 'Diagnosis')
end
