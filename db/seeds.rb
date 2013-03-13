# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

loc = Location.create(:name => "Test Hospital", :location_type => 1, :can_have_patients => false)
loc = Location.create(:name => "ICU", :location_type => 2, :can_have_patients => false, :parent_id => loc.id)
bed1 = Location.create(:name => "F101", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed2 = Location.create(:name => "F102", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed3 = Location.create(:name => "F103", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)

BodySystem.create(:name => "Neurology", :order => 1)
BodySystem.create(:name => "Pulmonary", :order => 2)
BodySystem.create(:name => "Cardiology", :order => 3)
BodySystem.create(:name => "Stomach", :order => 4)
BodySystem.create(:name => "Kidney", :order => 5)
BodySystem.create(:name => "Temperature", :order => 6)
BodySystem.create(:name => "Laboratory", :order => 7)

pat1 = Patient.create(:first_name => "Jon", :last_name => "Doe", :middle_name => "", :source_mrn =>  "T100001")

PatientLocation.create(:location_id => bed1.id, :patient_id => pat1.id)

Alert.create(:body_system_id => 1, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Sample alert", :status => 1)
Alert.create(:body_system_id => 2, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Sample alert", :status => 2)
Alert.create(:body_system_id => 3, :patient_id => pat1.id, :alert_type => 1, :severity => 3, :description => "Sample alert", :status => 1, :acknowledged_on => Time.now)

