require 'csv'

namespace :import do
  desc "Imports a CSV file containing patient data"
  task :patient_data => :environment do
    CSV.foreach(ENV['FILE'], :headers => true) do |row|
      patient = establish_patient row[0], row[1], row[2]
      Observation.create(:code_system => row[3], :code => row[4], :name => row[5], :observed_on => row[6], :value => row[8], :units => row[9], :patient_id => patient.id)
    end
  end
  
  def establish_patient mrn, first_name, last_name
    patient = Patient.find_by_source_mrn(mrn)
    return patient unless patient.blank?
    Patient.create(:source_mrn => mrn, :first_name => first_name, :last_name => last_name)
  end
end
