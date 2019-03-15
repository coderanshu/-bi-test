# == Schema Information
#
# Table name: questions
#
#  id                :integer          not null, primary key
#  guideline_step_id :integer
#  code              :string(255)
#  display           :string(255)
#  question_type     :string(255)
#  constraints       :string(255)
#  order             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  checklist_id      :integer
#

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
