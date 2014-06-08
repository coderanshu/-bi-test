class RenalGuidelinesJune2014 < ActiveRecord::Migration
  def up
    hvlm = Guideline.find_by_code("RENAL_HVLM")
    unless hvlm.blank?
      hvlm_step = GuidelineStep.create(:guideline_id => hvlm.id, :name => "Low systolic blood pressure", :description => "Systolic blood pressure < 100 mm Hg", :order => 2)
      Question.create(:guideline_step_id => hvlm_step.id, :code => "hvlm_low_sbp", :display => "Systolic blood pressure < 100 mm Hg", :question_type => "choice", :constraints => "YesNo")
    end
  end

  def down
    hvlm = Guideline.find_by_code("RENAL_HVLM")
    unless hvlm.blank?
      hvlm.guideline_steps.find_by_order(2).delete
      Question.find_by_guideline_step_id_and_code(hvlm_step.id, "hvlm_low_sbp").delete
    end
  end

  def delete_record question_code, guideline_code
    Question.find_all_by_code(question_code).last.delete
    guideline = Guideline.find_by_code(guideline_code)
    GuidelineStep.find_all_by_guideline_id(guideline.id).each { |x| x.delete }
    guideline.delete
  end
end
