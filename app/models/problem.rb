# == Schema Information
#
# Table name: problems
#
#  id             :integer          not null, primary key
#  observation_id :integer
#  status         :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  alert_id       :integer
#

class Problem < ActiveRecord::Base
  belongs_to :observation
  belongs_to :alert
  attr_accessible :observation_id, :status, :alert_id

  scope :active, where("problems.status = ?", 'Active')
  scope :possible, where("problems.status = ?", 'Possible')
  scope :diagnosis, where("problems.status = ?", 'Diagnosis')
  scope :updated_since, lambda { |last_update| where("problems.updated_at >= ? OR problems.created_at >= ?", last_update, last_update) }
end
