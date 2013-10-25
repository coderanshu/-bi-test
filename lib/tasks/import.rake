require 'csv'

namespace :import do
  desc "Imports a CSV file containing patient data"
  task :patient_data => :environment do
    CSV.foreach(ENV['FILE']) do |row|
      puts row
    end
  end

end
