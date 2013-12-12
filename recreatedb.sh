RAILS_ENV=development bundle exec rake db:drop
RAILS_ENV=development bundle exec rake db:setup
RAILS_ENV=development bundle exec rake import:patient_data FILE=/c/Development/BI/EHRWorksheet.csv
