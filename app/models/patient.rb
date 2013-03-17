class Patient < ActiveRecord::Base
  has_many :patient_locations
  has_many :patient_guidelines
  has_many :guidelines, :through => :patient_guidelines
  has_many :alerts
  attr_accessible :first_name, :last_name, :middle_name, :prefix, :source_mrn, :suffix

  def name
    first_name << " " << last_name  
  end
end
