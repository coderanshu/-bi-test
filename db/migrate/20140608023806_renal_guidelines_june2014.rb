class RenalGuidelinesJune2014 < ActiveRecord::Migration
  def up
    hvlm = Guideline.find_by_code("RENAL_HVLM")
    unless hvlm.blank?
      hvlm_step = GuidelineStep.create(:guideline_id => hvlm.id, :name => "Low systolic blood pressure", :description => "Systolic blood pressure < 100 mm Hg", :order => 2)
      Question.create(:guideline_step_id => hvlm_step.id, :code => "hvlm_low_sbp", :display => "Systolic blood pressure < 100 mm Hg", :question_type => "choice", :constraints => "YesNo")
    end

    # 55 - Gap acidemia
    gapacid = Guideline.create(:name => "Gap Acidemia", :code => "RENAL_GAP_ACIDEMIA",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 5)
    gapacid_step = GuidelineStep.create(:guideline_id => gapacid.id, :name => "Serum sodium (mEq/L)", :description => "Serum sodium (mEq/L)", :order => 1)
    Question.create(:guideline_step_id => gapacid_step.id, :code => "serum_sodium", :display => "Serum sodium (mEq/L)", :question_type => "text", :constraints => "integer")
    gapacid_step = GuidelineStep.create(:guideline_id => gapacid.id, :name => "Serum chloride (mEq/L)", :description => "Serum chloride (mEq/L)", :order => 2)
    Question.create(:guideline_step_id => gapacid_step.id, :code => "serum_chloride", :display => "Serum chloride (mEq/L)", :question_type => "text", :constraints => "integer")
    gapacid_step = GuidelineStep.create(:guideline_id => gapacid.id, :name => "HCO3 (mmol/L)", :description => "HCO3 (mmol/L)", :order => 3)
    Question.create(:guideline_step_id => gapacid_step.id, :code => "1963-8", :display => "HCO3 (mmol/L)", :question_type => "text", :constraints => "integer")
  end

  def down
    hvlm = Guideline.find_by_code("RENAL_HVLM")
    unless hvlm.blank?
      hvlm_step = hvlm.guideline_steps.find_by_order(2)
      Question.find_by_guideline_step_id_and_code(hvlm_step.id, "hvlm_low_sbp").delete
      hvlm_step.delete
    end

    delete_guideline "RENAL_GAP_ACIDEMIA"
  end

  def delete_guideline guideline_code
    guideline = Guideline.find_by_code(guideline_code)
    unless guideline.nil?
      GuidelineStep.find_all_by_guideline_id(guideline.id).each do |x|
        x.questions.each{ |q| q.delete }
        x.delete
      end
      guideline.delete
    end
  end
end
