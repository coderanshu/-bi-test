# == Schema Information
#
# Table name: guidelines
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  organization   :string(255)
#  url            :string(255)
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  body_system_id :integer
#  code           :string(255)
#

require 'spec_helper'

describe Guideline do
  pending "add some examples to (or delete) #{__FILE__}"
end
