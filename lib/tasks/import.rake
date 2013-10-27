require 'csv'

namespace :import do
  desc "Imports a CSV file containing patient data"
  task :patient_data => :environment do
    CSV.foreach(ENV['FILE']) do |row|
      patient = establish_patient row[0]
      Observation.create(:code_system => row[1], :code => row[2], :name => row[3], :observed_on => row[4], :value => row[6], :units => row[7], :patient_id => patient.id)
    end
  end
  
  def establish_patient mrn
    patient = Patient.find_by_source_mrn(mrn)
    return patient unless patient.blank?
    Patient.create(:source_mrn => mrn)
  end
end
