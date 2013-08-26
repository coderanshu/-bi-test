# == Schema Information
#
# Table name: alerts
#
#  id               :integer          not null, primary key
#  patient_id       :integer
#  body_system_id   :integer
#  alert_type       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  description      :string(255)
#  severity         :integer
#  status           :integer
#  acknowledged_id  :integer
#  acknowledged_on  :datetime
#  expires_on       :datetime
#  action_on_expire :integer
#  guideline_id     :integer
#

require 'spec_helper'

describe Alert do
  pending "add some examples to (or delete) #{__FILE__}"
end
