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

class Question < ActiveRecord::Base
  belongs_to :guideline_step
  attr_accessible :code, :constraints, :display, :guideline_step_id, :order, :question_type, :checklist_id
end
