# == Schema Information
#
# Table name: patient_guideline_actions
#
#  id                   :integer          not null, primary key
#  patient_id           :integer
#  guideline_action_id  :integer
#  patient_guideline_id :integer
#  acted_id             :integer
#  acted_on             :datetime
#  action               :string(255)
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  details              :text
#

require 'spec_helper'

describe PatientGuidelineAction do
  pending "add some examples to (or delete) #{__FILE__}"
end
