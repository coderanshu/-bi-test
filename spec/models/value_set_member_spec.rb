# == Schema Information
#
# Table name: value_set_members
#
#  id           :integer          not null, primary key
#  value_set_id :integer
#  code         :string(255)
#  name         :string(255)
#  description  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe ValueSetMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
