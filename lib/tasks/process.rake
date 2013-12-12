require "./lib/bi-test-processor"

namespace :process do
  desc "Imports a CSV file containing patient data"
  task :run => :environment do
    loop do
      Processor.execute
      sleep 10
    end
  end
end