# == Schema Information
#
# Table name: alert_responses
#
#  id            :integer          not null, primary key
#  alert_id      :integer
#  user_id       :integer
#  response_type :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AlertResponse < ActiveRecord::Base
  belongs_to :alert
  attr_accessible :alert_id, :response_type, :user_id
end
