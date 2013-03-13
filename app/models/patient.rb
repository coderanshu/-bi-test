class Patient < ActiveRecord::Base
  has_many :patient_locations
  has_many :alerts
  attr_accessible :first_name, :last_name, :middle_name, :prefix, :source_mrn, :suffix
end
