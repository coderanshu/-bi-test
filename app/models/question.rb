class Question < ActiveRecord::Base
  belongs_to :guideline_step
  attr_accessible :code, :constraints, :display, :guideline_step_id, :order, :question_type
end
