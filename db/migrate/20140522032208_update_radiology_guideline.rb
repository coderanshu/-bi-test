require 'guideline'
require 'guideline_step'
require 'question'

class UpdateRadiologyGuideline < ActiveRecord::Migration
  def up
    # 24 - Acute respiratory distress syndrome
    ards = Guideline.create(:name => "Acute respiratory distress syndrome", :code => "RESPIRATORY_ARDS",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 2)
    ards_step = GuidelineStep.create(:guideline_id => ards.id, :name => "Low Pressure Ratio", :description => "Ratio of partial pressure of oxygen / fraction of inspired oxygen < 300", :order => 1)
    Question.create(:guideline_step_id => ards_step.id, :code => "oxygen_ratio_below_300", :display => "Ratio of partial pressure of oxygen / fraction of inspired oxygen < 300", :question_type => "choice", :constraints => "YesNo")
    ards_step = GuidelineStep.create(:guideline_id => ards.id, :name => "Confirmed chest radiograph", :description => "Chest radiograph confirmed as compatible with ARDS diagnosis", :order => 2)
    Question.create(:guideline_step_id => ards_step.id, :code => "ards_confirmed_chest_radiograph", :display => "Chest radiograph is consistent with diagnosis", :question_type => "choice", :constraints => "YesNo")
    GuidelineAction.create(:guideline_id => ards.id, :text => "Recommended tidal volume 6 mL per kg of ideal body weight")

    pec = Guideline.find_by_code("RESPIRATORY_PEC")
    unless pec.blank?
      pec_step = GuidelineStep.find_by_guideline_id_and_order(pec.id, 2)
      pec_step.update_attributes(:description => "Arterial pCO2 > 50 and pH > 7.45")
      pec_step.questions.first.update_attributes(:display => "Arterial pCO2 > 50 and pH > 7.45")
    end
  end

  def down
    delete_record("two_low_heart_rate", "RESPIRATORY_ARDS")

    pec = Guideline.find_by_code("RESPIRATORY_PEC")
    unless pec.blank?
      pec_step = GuidelineStep.find_by_guideline_id_and_order(pec.id, 2)
      pec_step.update_attributes(:description => "Arterial pCO2 > 50 and pH < 7.35")
      pec_step.questions.first.update_attributes(:display => "Arterial pCO2 > 50 and pH < 7.35")
    end
  end

  def delete_record question_code, guideline_code
    Question.find_all_by_code(question_code).last.delete
    guideline = Guideline.find_by_code(guideline_code)
    GuidelineAction.find_all_by_guideline_id(guideline.id).each { |x| x.delete }
    GuidelineStep.find_all_by_guideline_id(guideline.id).each { |x| x.delete }
    guideline.delete
  end
end
