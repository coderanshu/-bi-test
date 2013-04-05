# Define our users for the system
User.create(:id => 1, :username => "luke", :password => "lukebi", :password_confirmation => "lukebi", :email => "test@test.com")
User.create(:id => 2, :username => "will", :password => "willbi", :password_confirmation => "willbi", :email => "test2@test.com")
User.create(:id => 3, :username => "david", :password => "davidbi", :password_confirmation => "davidbi", :email => "test3@test.com")
User.create(:id => 4, :username => "andrew", :password => "andrewbi", :password_confirmation => "andrewbi", :email => "test4@test.com")

# Define the lookup list of body systems
BodySystem.create(:name => "Neurologic", :order => 1)
BodySystem.create(:name => "Respiratory", :order => 2)
BodySystem.create(:name => "Cardiovascular", :order => 3)
BodySystem.create(:name => "Gastrointestinal", :order => 4)
BodySystem.create(:name => "Renal", :order => 5)
BodySystem.create(:name => "Infectious", :order => 6)
BodySystem.create(:name => "Hematology", :order => 7)

# Define the guideline that we're using for our example
guideline = Guideline.create(:name => "Improving Surveillance for Ventilator-Associated Events in Adults", :code => "PULMONARY_VAP",
  :organization => "Centers for Disease Control and Prevention (CDC)",
  :url => "", :description => "", :body_system_id => 2)
step1 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 1", :description => "On ventilator [[ventilator_days]] days (start [[ventilator_start]])", :order => 1)
step2 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 2", :description => "Min. daily FiO2 increased 0.20 or more over baseline for [[fio2_increase_days]] days", :order => 2)
step3 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 3", :description => "Temperature [[temperature]]", :order => 3)
step4 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 4", :description => "On antimicrobial agent ([[antimicrobial_agent]]) for [[ama_days]] days.", :order => 4)
step5 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 5", :description => "Purulent respiratory secretions (confirmed [[purulent_secretions_date]])", :order => 5)

ami = Guideline.create(:name => "Acute Myocardial Infarction", :code => "CARDIAC_AMI",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 3)
ami_step = GuidelineStep.create(:guideline_id => ami.id, :name => "Step 1", :description => "Cardiac troponin I above threshold ([[cardiac_troponin_i]])", :order => 1)
Guideline.create(:name => "Cardiac 2", :code => "CARDIAC_31",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 3)

# Give the guidelines some questions that can be asked to fill in missing data
q1 = Question.create(:guideline_step_id => step1.id, :code => "ventilator_days", :display => "# days on ventilator", :question_type => "text", :constraints => "integer")
q2 = Question.create(:guideline_step_id => step5.id, :code => "purulent_secretions", :display => "Is there a purulent respiratory secretion?", :question_type => "choice", :constraints => "YesNo")
q3 = Question.create(:guideline_step_id => ami_step.id, :code => "cardiac_troponin_i", :display => "Cardiac troponin I", :question_type => "text", :constraints => "integer")

vs1 = ValueSet.create(:code => "YesNo", :name => "Yes/No Response", :description => "", :source => "")
ValueSetMember.create(:value_set_id => vs1.id, :code => "Y", :name => "Yes")
ValueSetMember.create(:value_set_id => vs1.id, :code => "N", :name => "No")
ValueSetMember.create(:value_set_id => vs1.id, :code => "U", :name => "Unknown")

# Set up our example hospital with one unit and 3 beds
loc = Location.create(:name => "Test Hospital", :location_type => 1, :can_have_patients => false)
loc = Location.create(:name => "ICU", :location_type => 2, :can_have_patients => false, :parent_id => loc.id)
bed1 = Location.create(:name => "F101", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed2 = Location.create(:name => "F102", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed3 = Location.create(:name => "F103", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed4 = Location.create(:name => "F104", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)

# Populate beds with patients
pat1 = Patient.create(:first_name => "Jon", :last_name => "Doe", :middle_name => "", :source_mrn =>  "T100001")
PatientLocation.create(:location_id => bed1.id, :patient_id => pat1.id, :status => 1)
pat2 = Patient.create(:first_name => "Jane", :last_name => "Jones", :middle_name => "", :source_mrn =>  "T100002")
PatientLocation.create(:location_id => bed3.id, :patient_id => pat2.id, :status => 1)
pat3 = Patient.create(:first_name => "Cardiac", :last_name => "Test", :middle_name => "", :source_mrn =>  "T100003")
PatientLocation.create(:location_id => bed4.id, :patient_id => pat3.id, :status => 1)

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
Observation.create(:patient_id => pat1.id, :name => "ventilator_days", :value => "5", :question_id => q1.id)
Observation.create(:patient_id => pat1.id, :name => "ventilator_start", :value => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
Observation.create(:patient_id => pat1.id, :name => "temperature", :value => "40 C")
Observation.create(:patient_id => pat1.id, :name => "fio2_increase_days", :value => "3")
Observation.create(:patient_id => pat1.id, :name => "antimicrobial_agent", :value => "PIPTAZ, VANC")
Observation.create(:patient_id => pat1.id, :name => "ama_days", :value => "4")
Observation.create(:patient_id => pat1.id, :name => "purulent_secretions", :value => "Y", :question_id => q2.id)
#Observation.create(:patient_id => pat1.id, :name => "purulent_secretions_date", :value_timestamp => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))

Observation.create(:patient_id => pat2.id, :name => "ventilator_days", :value => "2")
Observation.create(:patient_id => pat2.id, :name => "ventilator_start", :value => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
Observation.create(:patient_id => pat2.id, :name => "temperature", :value => "32 C")
Observation.create(:patient_id => pat2.id, :name => "fio2_increase_days", :value => "0")

Observation.create(:patient_id => pat3.id, :name => "cardiac_troponin_i", :code => "CTI", :code_system => "LAB", :value => "3", :units => "mcg/mL")


# Seed some alerts for the patients
Alert.create(:body_system_id => 1, :patient_id => pat1.id, :alert_type => 1, :severity => 3, :description => "Neurological signs trending towards decreased function", :status => 1)
Alert.create(:body_system_id => 3, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Sample alert", :status => 2)
alert = Alert.create(:body_system_id => 2, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Possible Ventilator-Associated Pneumonia", :status => 1, :acknowledged_on => Time.now)


