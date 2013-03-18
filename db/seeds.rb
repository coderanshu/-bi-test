# Define our users for the system
User.create(:id => 1, :username => "luke", :password => "lukebi", :password_confirmation => "lukebi", :email => "test@test.com")
User.create(:id => 2, :username => "will", :password => "willbi", :password_confirmation => "willbi", :email => "test2@test.com")
User.create(:id => 3, :username => "david", :password => "davidbi", :password_confirmation => "davidbi", :email => "test3@test.com")
User.create(:id => 4, :username => "andrew", :password => "andrewbi", :password_confirmation => "andrewbi", :email => "test4@test.com")

# Define the lookup list of body systems
BodySystem.create(:name => "Neurology", :order => 1)
BodySystem.create(:name => "Pulmonary", :order => 2)
BodySystem.create(:name => "Cardiology", :order => 3)
BodySystem.create(:name => "Stomach", :order => 4)
BodySystem.create(:name => "Kidney", :order => 5)
BodySystem.create(:name => "Temperature", :order => 6)
BodySystem.create(:name => "Laboratory", :order => 7)

# Define the guideline that we're using for our example
guideline = Guideline.create(:name => "Improving Surveillance for Ventilator-Associated Events in Adults",
  :organization => "Centers for Disease Control and Prevention (CDC)",
  :url => "", :description => "", :body_system_id => 2)
step1 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 1", :description => "On ventilator [[ventilator_days]] days (start [[ventilator_start]])", :order => 1)
step2 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 2", :description => "Min. daily FiO2 increased 0.20 or more over baseline for [[fio2_increase_days]] days", :order => 2)
step3 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 3", :description => "Temperature [[temperature]]", :order => 3)
step4 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 4", :description => "On antimicrobial agent ([[antimicrobial_agent]]) for [[ama_days]] days.", :order => 4)
step5 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 5", :description => "Purulent respiratory secretions (confirmed [[purulent_secretions_date]])", :order => 5)

# Set up our example hospital with one unit and 3 beds
loc = Location.create(:name => "Test Hospital", :location_type => 1, :can_have_patients => false)
loc = Location.create(:name => "ICU", :location_type => 2, :can_have_patients => false, :parent_id => loc.id)
bed1 = Location.create(:name => "F101", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed2 = Location.create(:name => "F102", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed3 = Location.create(:name => "F103", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)

# Populate beds with patients
pat1 = Patient.create(:first_name => "Jon", :last_name => "Doe", :middle_name => "", :source_mrn =>  "T100001")
PatientLocation.create(:location_id => bed1.id, :patient_id => pat1.id)
pat2 = Patient.create(:first_name => "Jane", :last_name => "Jones", :middle_name => "", :source_mrn =>  "T100002")
PatientLocation.create(:location_id => bed3.id, :patient_id => pat2.id)

# Now put our patients on the guideline
pg1 = PatientGuideline.create(:patient_id => pat1.id, :guideline_id => guideline.id, :status => 1)
PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step1.id)
PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step2.id)
PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step3.id)
PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step4.id)
PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step5.id)
pg2 = PatientGuideline.create(:patient_id => pat2.id, :guideline_id => guideline.id, :status => 1)
PatientGuidelineStep.create(:patient_guideline_id => pg2.id, :guideline_step_id => step1.id)

# Make some observations relevant to the data
Observation.create(:patient_id => pat1.id, :name => "ventilator_days", :value_numeric => 5)
Observation.create(:patient_id => pat1.id, :name => "ventilator_start", :value_timestamp => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
Observation.create(:patient_id => pat1.id, :name => "temperature", :value_text => "40 C")
Observation.create(:patient_id => pat1.id, :name => "fio2_increase_days", :value_numeric => 3)
Observation.create(:patient_id => pat1.id, :name => "antimicrobial_agent", :value_text => "PIPTAZ, VANC")
Observation.create(:patient_id => pat1.id, :name => "ama_days", :value_text => 4)
Observation.create(:patient_id => pat1.id, :name => "purulent_secretions_date", :value_timestamp => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))

Observation.create(:patient_id => pat2.id, :name => "ventilator_days", :value_numeric => 2)
Observation.create(:patient_id => pat2.id, :name => "ventilator_start", :value_timestamp => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
Observation.create(:patient_id => pat2.id, :name => "temperature", :value_text => "32 C")
Observation.create(:patient_id => pat2.id, :name => "fio2_increase_days", :value_numeric => 0)


# Seed some alerts for the patients
Alert.create(:body_system_id => 1, :patient_id => pat1.id, :alert_type => 1, :severity => 3, :description => "Neurological signs trending towards decreased function", :status => 1)
Alert.create(:body_system_id => 3, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Sample alert", :status => 2)
alert = Alert.create(:body_system_id => 2, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Possible Ventilator-Associated Pneumonia", :status => 1, :acknowledged_on => Time.now)


