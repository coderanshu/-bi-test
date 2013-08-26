# == Schema Information
#
# Table name: patient_locations
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  location_id :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe PatientLocation do
  pending "add some examples to (or delete) #{__FILE__}"
end
