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

require 'spec_helper'

describe RiskProfile do
  pending "add some examples to (or delete) #{__FILE__}"
end
