class Observation < ActiveRecord::Base
  attr_accessible :name, :value_numeric, :value_text, :value_timestamp, :patient_id

  def value
    val = self.value_numeric.to_s
    val = self.value_text if val.blank?
    val = self.value_timestamp.strftime('%m/%d/%Y') if val.blank?
    val = "" if val.blank?
    val
  end
end
