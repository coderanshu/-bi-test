require 'require_all'
require_all 'lib'
# require "./lib/guideline_manager"
# require "./lib/processors/cardiac"
# require "./lib/processors/respiratory"
# require "./lib/processors/renal"
# require "./lib/processors/neurologic"
# require "./lib/processors/infectious"
# require "./lib/processors/hematology"
# require "./lib/processors/gastrointestinal"

module Processor
  module_function

  def execute
    Cardiac.new(Patient.all).execute
    Respiratory.new(Patient.all).execute
    Renal.new(Patient.all).execute
    Neurologic.new(Patient.all).execute
    Infectious.new(Patient.all).execute
    Hematology.new(Patient.all).execute
    Gastrointestinal.new(Patient.all).execute
  end
end