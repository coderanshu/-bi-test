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
#  gender      :string(255)
#

require 'spec_helper'

describe Patient do
  pending "add some examples to (or delete) #{__FILE__}"
end
