class Question < ActiveRecord::Base
  attr_accessible :code, :constraints, :display, :guideline_step_id, :order, :question_type
end
