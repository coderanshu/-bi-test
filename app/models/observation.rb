class Observation < ActiveRecord::Base
  attr_accessible :name, :value, :patient_id, :question_id


  belongs_to :question

  # Keep this in case we want to split apart value by type in the future.
  # attr_accessible :value_numeric, :value_text, :value_timestamp, 
  #def value
  #  val = self.value_numeric.to_s
  #  val = self.value_text if val.blank?
  #  val = self.value_timestamp.strftime('%m/%d/%Y') if val.blank?
  #  val = "" if val.blank?
  #  val
  #end
end
