class Response < ActiveRecord::Base
  attr_accessible :patient_id, :question_id, :value
end
