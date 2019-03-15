# == Schema Information
#
# Table name: risk_profiles
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RiskProfile < ActiveRecord::Base
  attr_accessible :description, :patient_id
end
