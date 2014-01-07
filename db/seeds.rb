# Define our users for the system
User.create(:id => 1, :username => "luke", :password => "lukebi", :password_confirmation => "lukebi", :email => "test@test.com", :display_name => "Luke Rasmussen")
User.create(:id => 2, :username => "will", :password => "willbi", :password_confirmation => "willbi", :email => "test2@test.com", :display_name => "Will Thompson")
User.create(:id => 3, :username => "david", :password => "davidbi", :password_confirmation => "davidbi", :email => "test3@test.com", :display_name => "Dr. David Liebovitz")
User.create(:id => 4, :username => "andrew", :password => "andrewbi", :password_confirmation => "andrewbi", :email => "test4@test.com", :display_name => "Dr. Andrew Naidech")

# Define the lookup list of body systems
BodySystem.create(:name => "Neurologic", :order => 1)
BodySystem.create(:name => "Respiratory", :order => 2)
BodySystem.create(:name => "Cardiovascular", :order => 3)
BodySystem.create(:name => "Gastrointestinal", :order => 4)
BodySystem.create(:name => "Renal", :order => 5)
BodySystem.create(:name => "Infectious", :order => 6)
BodySystem.create(:name => "Hematology", :order => 7)

# Define the guideline that we're using for our example
# guideline = Guideline.create(:name => "Improving Surveillance for Ventilator-Associated Events in Adults", :code => "PULMONARY_VAP",
  # :organization => "Centers for Disease Control and Prevention (CDC)",
  # :url => "", :description => "", :body_system_id => 2)
# step1 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 1", :description => "On ventilator [[ventilator_days]] days (start [[ventilator_start]])", :order => 1)
# step2 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 2", :description => "Min. daily FiO2 increased 0.20 or more over baseline for [[fio2_increase_days]] days", :order => 2)
# step3 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 3", :description => "Temperature [[temperature]]", :order => 3)
# step4 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 4", :description => "On antimicrobial agent ([[antimicrobial_agent]]) for [[ama_days]] days.", :order => 4)
# step5 = GuidelineStep.create(:guideline_id => guideline.id, :name => "Step 5", :description => "Purulent respiratory secretions (confirmed [[purulent_secretions_date]])", :order => 5)

# ------------ NEUROLOGIC -----------
# 10 - Delerium
del = Guideline.create(:name => "Delerium", :code => "NEUROLOGIC_DELERIUM",
  :organization => "Bedside Intelligence",
  :url => "http://www.icudelirium.org", :description => "", :body_system_id => 1)
del_step = GuidelineStep.create(:guideline_id => del.id, :name => "Positive Delerium Screening", :description => "Positive delerium screening", :order => 1)
Question.create(:guideline_step_id => del_step.id, :code => "delerium_screening", :display => "Positive delerium screening (not in 'green zone')", :question_type => "choice", :constraints => "YesNo")

# 11 - Alcohol Withdrawal
aw = Guideline.create(:name => "Alcohol Withdrawal", :code => "NEUROLOGIC_AW",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 1)
aw_step = GuidelineStep.create(:guideline_id => aw.id, :name => "CIWA score", :description => "CIWA score >= 15", :order => 1)
Question.create(:guideline_step_id => aw_step.id, :code => "ciwa_score", :display => "CIWA score", :question_type => "text", :constraints => "integer")

# 12 - Altered Mental Status
ams = Guideline.create(:name => "Altered Mental Status", :code => "NEUROLOGIC_AMS",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 1)
ams_step = GuidelineStep.create(:guideline_id => ams.id, :name => "Glasgow Coma Scale decrease", :description => "Glasgow Coma Scale decrease by at least 2 points", :order => 1)
Question.create(:guideline_step_id => ams_step.id, :code => "glasgow_coma_decrease", :display => "Glasgow Coma Scale decrease by at least 2 points", :question_type => "choice", :constraints => "YesNo")
ams_step = GuidelineStep.create(:guideline_id => ams.id, :name => "Glasgow Coma Scale", :description => "Glasgow Coma Scale <= 8", :order => 2)
Question.create(:guideline_step_id => ams_step.id, :code => "glasgow_coma_scale", :display => "Glasgow Coma Scale score", :question_type => "text", :constraints => "integer")


# ------------ RESPIRATORY -----------
# 20 - Pulmonary Embolism Concern
pec = Guideline.create(:name => "Pulmonary Embolism Concern", :code => "RESPIRATORY_PEC",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 2)
pec_step = GuidelineStep.create(:guideline_id => pec.id, :name => "High HR", :description => "Two readings in an hour with heart rate >100", :order => 1)
Question.create(:guideline_step_id => pec_step.id, :code => "two_high_heart_rate_100", :display => "Two HR >100 in the past hour", :question_type => "choice", :constraints => "YesNo")
pec_step = GuidelineStep.create(:guideline_id => pec.id, :name => "New respiratory acidosis", :description => "Arterial pCO2 > 50 and pH < 7.35", :order => 2)
Question.create(:guideline_step_id => pec_step.id, :code => "new_respiratory_acidosis", :display => "Arterial pCO2 > 50 and pH < 7.35", :question_type => "choice", :constraints => "YesNo")

# 21 - Acute Lung Injury Concern Concern
alic = Guideline.create(:name => "Acute Lung Injury Concern", :code => "RESPIRATORY_ALIC",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 2)
alic_step = GuidelineStep.create(:guideline_id => alic.id, :name => "Low Pressure Ratio", :description => "Ratio of partial pressure of oxygen / fraction of inspired oxygen < 300", :order => 1)
Question.create(:guideline_step_id => alic_step.id, :code => "oxygen_ratio_below_300", :display => "Ratio of partial pressure of oxygen / fraction of inspired oxygen < 300", :question_type => "choice", :constraints => "YesNo")
alic_step = GuidelineStep.create(:guideline_id => alic.id, :name => "Confirmed chest radiograph", :description => "Chest radiograph confirmed as compatible with ALI diagnosis", :order => 2)
Question.create(:guideline_step_id => alic_step.id, :code => "alic_confirmed_chest_radiograph", :display => "Chest radiograph is consistent with diagnosis", :question_type => "choice", :constraints => "YesNo")
alic_step = GuidelineStep.create(:guideline_id => alic.id, :name => "Ventilator tidal volume to ideal body weight >= 8mL/kg", :description => "Ratio of ventilator tidal volume to ideal body weight >= 8 mL/kg", :order => 3)
Question.create(:guideline_step_id => alic_step.id, :code => "alic_tidal_volume", :display => "Is the ratio of ventilator tidal volume to ideal body weight >= 8 mL/kg", :question_type => "choice", :constraints => "YesNo")
alic_step = GuidelineStep.create(:guideline_id => alic.id, :name => "Lung protective ventilation is appropriate", :description => "Lung protective ventilation is appropriate", :order => 4)
Question.create(:guideline_step_id => alic_step.id, :code => "alic_ventilation_appropriate", :display => "Lung protective ventilation is appropriate?", :question_type => "choice", :constraints => "YesNo")

# 22 - Readiness of Ventilator Weaning
rovw = Guideline.create(:name => "Readiness of Ventilator Weaning", :code => "RESPIRATORY_ROVW",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 2)
rovw_step = GuidelineStep.create(:guideline_id => rovw.id, :name => "Pressure support mode", :description => "Pressure support mode", :order => 1)
Question.create(:guideline_step_id => rovw_step.id, :code => "rovw_pressure_support_mode", :display => "Pressure support mode", :question_type => "choice", :constraints => "YesNo")
rovw_step = GuidelineStep.create(:guideline_id => rovw.id, :name => "5 cm H2O", :description => "Confirm if there is 5 cm H2O", :order => 2)
Question.create(:guideline_step_id => rovw_step.id, :code => "rovw_h2o", :display => "Is there 5 cm H2O", :question_type => "choice", :constraints => "YesNo")
rovw_step = GuidelineStep.create(:guideline_id => rovw.id, :name => "Fraction inspired O2 <= 0.4 for >= 2 hours", :description => "Is the fraction of inspired oxygen <= 0.4 for at least two hours that day", :order => 3)
Question.create(:guideline_step_id => rovw_step.id, :code => "rovw_fraction_o2", :display => "Is the fraction of inspired oxygen <= 0.4 for at least two hours that day", :question_type => "choice", :constraints => "YesNo")

# 23 - Ventilator Associated Condition
vac = Guideline.create(:name => "Ventilator Associated Condition", :code => "RESPIRATORY_VAC_CDC",
  :organization => "Centers for Disease Control and Prevention (CDC)",
  :url => "", :description => "", :body_system_id => 2)
vac_step = GuidelineStep.create(:guideline_id => vac.id, :name => "Step 1", :description => "On ventilator >=3 calendar days", :order => 1)
Question.create(:guideline_step_id => vac_step.id, :code => "vac_ventilator_days", :display => "# days on ventilator", :question_type => "text", :constraints => "integer")
vac_step = GuidelineStep.create(:guideline_id => vac.id, :name => "Step 2", :description => "Min. daily FiO2 increased 0.20 or more over baseline", :order => 2)
Question.create(:guideline_step_id => vac_step.id, :code => "fio2_increase_days", :display => "Min. daily FiO2 increased 0.20 or more over baseline for >=2 calendar days", :question_type => "choice", :constraints => "YesNo")
vac_step = GuidelineStep.create(:guideline_id => vac.id, :name => "Step 3", :description => "Temperature (F) >100.4 or <96.8", :order => 3)
Question.create(:guideline_step_id => vac_step.id, :code => "temperature", :display => "Temperature (F)", :question_type => "text", :constraints => "float")
vac_step = GuidelineStep.create(:guideline_id => vac.id, :name => "Step 4", :description => "On antimicrobial agent.", :order => 4)
Question.create(:guideline_step_id => vac_step.id, :code => "on_antimicro_agent", :display => "On antimicrobial agent for >= 4 calendar days", :question_type => "choice", :constraints => "YesNo")
vac_step = GuidelineStep.create(:guideline_id => vac.id, :name => "Step 5", :description => "Purulent respiratory secretions", :order => 5)
Question.create(:guideline_step_id => vac_step.id, :code => "vac_purulent_secretions", :display => "Purulent respiratory secretion?", :question_type => "choice", :constraints => "YesNo")
GuidelineAction.create(:guideline_id => vac.id, :text => "Order antibiotic")
#GuidelineAction.create(:guideline_id => vac.id, :text => "Discharge")


# ------------ CARDIAC ---------------
# 30 - Acute MI
ami = Guideline.create(:name => "Acute Myocardial Infarction", :code => "CARDIAC_AMI",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 3)
ami_step = GuidelineStep.create(:guideline_id => ami.id, :name => "High Cardiac Troponin I", :description => "Cardiac troponin I above threshold", :order => 1)
Question.create(:guideline_step_id => ami_step.id, :code => "cardiac_troponin_i", :display => "Cardiac toponin I (mcg/mL)", :question_type => "text", :constraints => "float")
GuidelineAction.create(:guideline_id => ami.id, :text => "Order medication")
# 31 - Abnormal High Function
ahf = Guideline.create(:name => "Abnormal High Function", :code => "CARDIAC_AHF",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 3)
ahf_step = GuidelineStep.create(:guideline_id => ahf.id, :name => "High BP", :description => "Two readings in an hour with systolic BP >200", :order => 1)
Question.create(:guideline_step_id => ahf_step.id, :code => "two_high_systolic_bp", :display => "Two systolic BP >200 in the past hour", :question_type => "choice", :constraints => "YesNo")
ahf_step = GuidelineStep.create(:guideline_id => ahf.id, :name => "High HR", :description => "Two readings in an hour with heart rate >150", :order => 2)
Question.create(:guideline_step_id => ahf_step.id, :code => "two_high_heart_rate", :display => "Two HR >150 in the past hour", :question_type => "choice", :constraints => "YesNo")
# 32 - Abnormal Low Function
alf = Guideline.create(:name => "Abnormal Low Function", :code => "CARDIAC_ALF",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 3)
alf_step = GuidelineStep.create(:guideline_id => alf.id, :name => "Low BP", :description => "Two readings in an hour with systolic BP <90", :order => 1)
Question.create(:guideline_step_id => alf_step.id, :code => "two_low_systolic_bp", :display => "Two systolic BP <90 in the past hour", :question_type => "choice", :constraints => "YesNo")
alf_step = GuidelineStep.create(:guideline_id => alf.id, :name => "Low HR", :description => "Two readings in an hour with heart rate <40", :order => 2)
Question.create(:guideline_step_id => alf_step.id, :code => "two_low_heart_rate", :display => "Two HR <40 in the past hour", :question_type => "choice", :constraints => "YesNo")


# ------------ GASTROINTESTINAL ---------------
# 40 - Liver Dysfunction
gild = Guideline.create(:name => "Liver Dysfunction", :code => "GI_LD",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 4)
gild_step = GuidelineStep.create(:guideline_id => gild.id, :name => "High AST", :description => "Aspartate aminotransferase > 96 IU/L", :order => 1)
Question.create(:guideline_step_id => gild_step.id, :code => "AST", :display => "Aspartate aminotransferase (IU/L)", :question_type => "text", :constraints => "integer")
gild_step = GuidelineStep.create(:guideline_id => gild.id, :name => "High ALT", :description => "Alanine aminotransferase > 80 IU/L", :order => 2)
Question.create(:guideline_step_id => gild_step.id, :code => "ALT", :display => "Alanine aminotransferase (IU/L)", :question_type => "text", :constraints => "integer")

# 41 - Pancreatitis
gip = Guideline.create(:name => "Pancreatitis", :code => "GI_PANCREATITIS",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 4)
gip_step = GuidelineStep.create(:guideline_id => gip.id, :name => "High amylase", :description => "Amylase > 180 IU/L", :order => 1)
Question.create(:guideline_step_id => gip_step.id, :code => "amylase", :display => "Amylase (IU/L)", :question_type => "text", :constraints => "integer")

# 42 - Cholecystitis
gic = Guideline.create(:name => "Cholecystitis", :code => "GI_CHOLECYSTITIS",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 4)
gic_step = GuidelineStep.create(:guideline_id => gic.id, :name => "High alkaline phosphatase", :description => "Alkaline phosphatase > 300 IU/L", :order => 1)
Question.create(:guideline_step_id => gic_step.id, :code => "ALP", :display => "Alkaline phospatase (IU/L)", :question_type => "text", :constraints => "integer")

# 43 - Malnutrition
gim = Guideline.create(:name => "Malnutrition", :code => "GI_MALNUTRITION",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 4)
gim_step = GuidelineStep.create(:guideline_id => gim.id, :name => "Low albumin", :description => "Albumin < 2 mg/dL", :order => 1)
Question.create(:guideline_step_id => gim_step.id, :code => "ALB", :display => "Albumin (mg/dL)", :question_type => "text", :constraints => "float")
gim_step = GuidelineStep.create(:guideline_id => gim.id, :name => "No nutrition", :description => "No nutrition (tube feeds or parenteral nutrition) for 3 days", :order => 2)
Question.create(:guideline_step_id => gim_step.id, :code => "no_nutrition_3_days", :display => "No nutrition (tube feeds or parenteral nutrition) for 3 days", :question_type => "choice", :constraints => "YesNo")


# ------------ RENAL ---------------
# 50 - Hypovolemia
hvlm = Guideline.create(:name => "Hypovolemia", :code => "RENAL_HVLM",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 5)
hvlm_step = GuidelineStep.create(:guideline_id => hvlm.id, :name => "Low venous pressure", :description => "Central venous pressure <= 3 mm Hg", :order => 1)
Question.create(:guideline_step_id => hvlm_step.id, :code => "hvlm_low_pressure", :display => "Central venous pressure <= 3 mm Hg", :question_type => "choice", :constraints => "YesNo")

# 51 - Hypovolemia
duo = Guideline.create(:name => "Decreased urinary output", :code => "RENAL_DUO",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 5)
duo_step = GuidelineStep.create(:guideline_id => duo.id, :name => "Decreased urinary output", :description => "Decreased urinary output", :order => 1)
Question.create(:guideline_step_id => duo_step.id, :code => "duo_decreased_output", :display => "Urinary output <30 mL / hour, averaged over the past 8 hours", :question_type => "choice", :constraints => "YesNo")

# 52 - Acute Kidney Injury
aki = Guideline.create(:name => "Acute Kidney Injury", :code => "RENAL_AKI",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 5)
aki_step = GuidelineStep.create(:guideline_id => aki.id, :name => "Creatinine >= 2.5 mg/dL", :description => "Creatinine >= 2.5 mg/dL", :order => 1)
Question.create(:guideline_step_id => aki_step.id, :code => "creatinine", :display => "Creatinine (mg/dL)", :question_type => "text", :constraints => "float")

# 53 - Hyponatremia
hpont = Guideline.create(:name => "Hyponatremia", :code => "RENAL_HPONT",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 5)
hpont_step = GuidelineStep.create(:guideline_id => hpont.id, :name => "Serum sodium concentration", :description => "Hyponatremia <130 mEq/L", :order => 1)
Question.create(:guideline_step_id => hpont_step.id, :code => "serum_sodium", :display => "Serum sodium concentration (mEq/L)", :question_type => "text", :constraints => "integer")

# 54 - Hypernatremia
hprnt = Guideline.create(:name => "Hypernatremia", :code => "RENAL_HPRNT",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 5)
hprnt_step = GuidelineStep.create(:guideline_id => hprnt.id, :name => "Serum sodium concentration", :description => "Hyponatremia >150 mEq/L", :order => 1)
Question.create(:guideline_step_id => hprnt_step.id, :code => "serum_sodium", :display => "Serum sodium concentration (mEq/L)", :question_type => "text", :constraints => "integer")


# ------------ INFECTIOUS ---------------
# 60 - Sepsis
sepsis = Guideline.create(:name => "Sepsis", :code => "INFECTIOUS_SEPSIS",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 6)
sepsis_step = GuidelineStep.create(:guideline_id => sepsis.id, :name => "Positive blood culture for sepsis", :description => "Positive blood culture for sepsis", :order => 1)
Question.create(:guideline_step_id => sepsis_step.id, :code => "positive_sepsis", :display => "Positive blood culture for sepsis", :question_type => "choice", :constraints => "YesNo")

# 62 - Positive urine culture
puc = Guideline.create(:name => "Positive urine culture", :code => "INFECTIOUS_PUC",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 6)
puc_step = GuidelineStep.create(:guideline_id => puc.id, :name => "Positive urine culture", :description => "Positive urine culture", :order => 1)
Question.create(:guideline_step_id => puc_step.id, :code => "positive_urine", :display => "Positive urine culture", :question_type => "choice", :constraints => "YesNo")

# 63 - Positive respiratory culture
prc = Guideline.create(:name => "Positive respiratory culture", :code => "INFECTIOUS_PRC",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 6)
prc_step = GuidelineStep.create(:guideline_id => prc.id, :name => "Positive respiratory culture", :description => "Positive respiratory culture", :order => 1)
Question.create(:guideline_step_id => prc_step.id, :code => "positive_respiratory", :display => "Positive respiratory culture", :question_type => "choice", :constraints => "YesNo")

# 64 - Fever
fever = Guideline.create(:name => "Fever", :code => "INFECTIOUS_FEVER",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 6)
fever_step = GuidelineStep.create(:guideline_id => fever.id, :name => "High temperature", :description => "Temperature >= 101.5 F", :order => 1)
Question.create(:guideline_step_id => fever_step.id, :code => "temperature", :display => "Temperature (F)", :question_type => "text", :constraints => "float")

# 65 - Bacteremia
bacteremia = Guideline.create(:name => "Bacteremia", :code => "INFECTIOUS_BACTEREMIA",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 6)
bacteremia_step = GuidelineStep.create(:guideline_id => bacteremia.id, :name => "Positive blood culture for bacteremia", :description => "Positive blood culture for bacteremia", :order => 1)
Question.create(:guideline_step_id => bacteremia_step.id, :code => "positive_bacteremia", :display => "Positive blood culture for bacteremia", :question_type => "choice", :constraints => "YesNo")



# ------------ HEMATOLOGY ---------------
# 70 - Abnormal low hemoglobin (anemia)
alhgb = Guideline.create(:name => "Abnormal low hemoglobin", :code => "HEMATOLOGY_ALHGB",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 7)
alhgb_step = GuidelineStep.create(:guideline_id => alhgb.id, :name => "Abnormal low hemoglobin", :description => "Hemoglobin <= 7.0 mg/dL", :order => 1)
Question.create(:guideline_step_id => alhgb_step.id, :code => "hemoglobin", :display => "Hemoglobin (mg/dL)", :question_type => "text", :constraints => "float")

# 71 - Abnormal low platelets
alp = Guideline.create(:name => "Abnormal low platelets", :code => "HEMATOLOGY_ALP",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 7)
alp_step = GuidelineStep.create(:guideline_id => alp.id, :name => "Abnormal low platelets", :description => "Platelets <50 per microliter or decrease of 50% from baseline measurement", :order => 1)
Question.create(:guideline_step_id => alp_step.id, :code => "abnormal_low_platelets", :display => "Platelets <50 per microliter or decrease of 50% from baseline measurement", :question_type => "choice", :constraints => "YesNo")

# 72 - Low absolute neutrophil count
alnc = Guideline.create(:name => "Abnormal low absolute neutrophil count", :code => "HEMATOLOGY_ALNC",
  :organization => "Bedside Intelligence",
  :url => "", :description => "", :body_system_id => 7)
alnc_step = GuidelineStep.create(:guideline_id => alnc.id, :name => "Abnormal low neutrophil count", :description => "Neutrophil count <= 500", :order => 1)
Question.create(:guideline_step_id => alnc_step.id, :code => "abnormal_low_neutrophil_count", :display => "Absolute neutrophil count <= 500", :question_type => "choice", :constraints => "YesNo")



# GuidelineAction.create(:guideline_id => guideline.id, :text => "Order antibiotic")
# GuidelineAction.create(:guideline_id => guideline.id, :text => "Discharge")
# GuidelineAction.create(:guideline_id => ami.id, :text => "Order medication")

# Give the guidelines some questions that can be asked to fill in missing data
# q1 = Question.create(:guideline_step_id => step1.id, :code => "ventilator_days", :display => "# days on ventilator", :question_type => "text", :constraints => "integer")
# q2 = Question.create(:guideline_step_id => step5.id, :code => "purulent_secretions", :display => "Is there a purulent respiratory secretion?", :question_type => "choice", :constraints => "YesNo")
# q3 = Question.create(:guideline_step_id => ami_step.id, :code => "cardiac_troponin_i", :display => "Cardiac troponin I", :question_type => "text", :constraints => "integer")

vs1 = ValueSet.create(:code => "YesNo", :name => "Yes/No Response", :description => "", :source => "")
ValueSetMember.create(:value_set_id => vs1.id, :code => "Y", :name => "Yes")
ValueSetMember.create(:value_set_id => vs1.id, :code => "N", :name => "No")
ValueSetMember.create(:value_set_id => vs1.id, :code => "U", :name => "Unknown")

# Set up our example hospital with one unit and 3 beds
root = Location.create(:name => "Test Hospital", :location_type => 1, :can_have_patients => false)
loc = Location.create(:name => "ICU", :location_type => 2, :can_have_patients => false, :parent_id => root.id)
loc2 = Location.create(:name => "NICU", :location_type => 2, :can_have_patients => false, :parent_id => root.id)
bed1 = Location.create(:name => "F101", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed2 = Location.create(:name => "F102", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed3 = Location.create(:name => "F103", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed4 = Location.create(:name => "F104", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed5 = Location.create(:name => "F105", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed6 = Location.create(:name => "F106", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed7 = Location.create(:name => "F107", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
bed8 = Location.create(:name => "F108", :location_type => 3, :can_have_patients => true, :parent_id => loc.id)
Location.create(:name => "F101", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F102", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F103", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F104", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F105", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F106", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F107", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)
Location.create(:name => "F108", :location_type => 3, :can_have_patients => true, :parent_id => loc2.id)

# Populate beds with patients
# pat1 = Patient.create(:first_name => "Jon", :last_name => "Doe", :middle_name => "", :source_mrn =>  "T100001")
# PatientLocation.create(:location_id => bed1.id, :patient_id => pat1.id, :status => 1)
# pat2 = Patient.create(:first_name => "Jane", :last_name => "Jones", :middle_name => "", :source_mrn =>  "T100002")
# PatientLocation.create(:location_id => bed3.id, :patient_id => pat2.id, :status => 1)
# pat3 = Patient.create(:first_name => "Cardiac", :last_name => "Test", :middle_name => "", :source_mrn =>  "T100003")
# PatientLocation.create(:location_id => bed4.id, :patient_id => pat3.id, :status => 1)

pat1 = Patient.create(:first_name => "Jon", :last_name => "Doe", :middle_name => "", :source_mrn =>  "1")
PatientLocation.create(:location_id => bed1.id, :patient_id => pat1.id, :status => 1)
pat2 = Patient.create(:first_name => "Jane", :last_name => "Smith", :middle_name => "", :source_mrn =>  "2")
PatientLocation.create(:location_id => bed2.id, :patient_id => pat2.id, :status => 1)
pat3 = Patient.create(:first_name => "Alfred", :last_name => "Jones", :middle_name => "", :source_mrn =>  "3")
PatientLocation.create(:location_id => bed3.id, :patient_id => pat3.id, :status => 1)
pat4 = Patient.create(:first_name => "Sally", :last_name => "Test", :middle_name => "", :source_mrn =>  "4")
PatientLocation.create(:location_id => bed4.id, :patient_id => pat4.id, :status => 1)
pat7 = Patient.create(:first_name => "Alice", :last_name => "Smythe", :middle_name => "", :source_mrn =>  "5")
PatientLocation.create(:location_id => bed7.id, :patient_id => pat7.id, :status => 1)

# Now put our patients on the guideline
# pg1 = PatientGuideline.create(:patient_id => pat1.id, :guideline_id => guideline.id, :status => 1)
# PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step1.id, :patient_id => pat1.id)
# PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step2.id, :patient_id => pat1.id)
# PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step3.id, :patient_id => pat1.id)
# PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step4.id, :patient_id => pat1.id)
# PatientGuidelineStep.create(:patient_guideline_id => pg1.id, :guideline_step_id => step5.id, :patient_id => pat1.id)
# pg2 = PatientGuideline.create(:patient_id => pat2.id, :guideline_id => guideline.id, :status => 1)
# PatientGuidelineStep.create(:patient_guideline_id => pg2.id, :guideline_step_id => step1.id, :patient_id => pat2.id)

# Make some observations relevant to the data
# Observation.create(:patient_id => pat1.id, :name => "ventilator_days", :value => "5", :question_id => q1.id)
# Observation.create(:patient_id => pat1.id, :name => "ventilator_start", :value => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
# Observation.create(:patient_id => pat1.id, :name => "temperature", :value => "40 C")
# Observation.create(:patient_id => pat1.id, :name => "fio2_increase_days", :value => "3")
# Observation.create(:patient_id => pat1.id, :name => "antimicrobial_agent", :value => "PIPTAZ, VANC")
# Observation.create(:patient_id => pat1.id, :name => "ama_days", :value => "4")
# Observation.create(:patient_id => pat1.id, :name => "purulent_secretions", :value => "Y", :question_id => q2.id)
# #Observation.create(:patient_id => pat1.id, :name => "purulent_secretions_date", :value_timestamp => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))

# Observation.create(:patient_id => pat2.id, :name => "ventilator_days", :value => "2")
# Observation.create(:patient_id => pat2.id, :name => "ventilator_start", :value => DateTime.strptime("01/25/2013 09:30", "%m/%d/%Y %H:%M"))
# Observation.create(:patient_id => pat2.id, :name => "temperature", :value => "32 C")
# Observation.create(:patient_id => pat2.id, :name => "fio2_increase_days", :value => "0")

# Observation.create(:patient_id => pat3.id, :name => "cardiac_troponin_i", :code => "CTI", :code_system => "LAB", :value => "3", :units => "mcg/mL")

# Make some problem list observations
#plo = Observation.create(:patient_id => pat1.id, :name => "Hyperlipidemia (disorder)", :value => "", :code_system => "SNOMEDCT", :code => "55822004")
#Problem.create(:observation_id => plo.id, :status => 'Active')
#plo = Observation.create(:patient_id => pat2.id, :name => "Chronic renal failure syndrome (disorder)", :value => "", :code_system => "SNOMEDCT", :code => "90688005")
#Problem.create(:observation_id => plo.id, :status => 'Active')

# Seed some alerts for the patients
# Alert.create(:body_system_id => 1, :patient_id => pat1.id, :alert_type => 1, :severity => 3, :description => "Neurological signs trending towards decreased function", :status => 1)
# Alert.create(:body_system_id => 3, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Sample alert", :status => 2)
# alert = Alert.create(:body_system_id => 2, :patient_id => pat1.id, :alert_type => 1, :severity => 5, :description => "Possible Ventilator-Associated Pneumonia", :status => 1, :acknowledged_on => Time.now)


# Set up known checklists
checklist = Checklist.create(:name => "Daily ICU Checklist", :description => "")
Question.create(:checklist_id => checklist.id, :code => "decrease_sedation", :display => "Can sedation be decreased: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "wean_vent_support", :display => "Can ventilatory support be weaned: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "remove_va_lines", :display => "Can any venous or arterial lines be removed: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "remove_cath", :display => "Can indwelling urinary catheter be removed: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "increase_nutrition", :display => "Is it appropriate to increase nutrition: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "receive_dvt_chem", :display => "Can the patient receive DVT chemoprophylaxis (to prevent deep venous thrombosis): ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "increase_mobility", :display => "Can the patient's mobility be increased: ", :question_type => "choice", :constraints => "YesNo")
Question.create(:checklist_id => checklist.id, :code => "stop_antibiotics", :display => "Can antibiotic coverage be stopped: ", :question_type => "choice", :constraints => "YesNo")


