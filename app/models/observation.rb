class Observation < ActiveRecord::Base
  attr_accessible :name, :value, :patient_id, :question_id, :code_system, :observed_on, :code, :units
  belongs_to :question

  scope :updated_since, lambda { |last_update| where("observations.updated_at >= ? OR observations.created_at >= ?", last_update, last_update) }

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
