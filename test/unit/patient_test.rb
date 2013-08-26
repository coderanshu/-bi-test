# == Schema Information
#
# Table name: patients
#
#  id          :integer          not null, primary key
#  source_mrn  :string(255)
#  prefix      :string(255)
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  suffix      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
