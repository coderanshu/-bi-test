class RespiratoryGuidelinesJune2014 < ActiveRecord::Migration
  def up
    # 25 - Pneumonia
    pneum = Guideline.create(:name => "Pneumonia", :code => "RESPIRATORY_PNEUMONIA",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 2)
    pneum_step = GuidelineStep.create(:guideline_id => pneum.id, :name => "Positive bronchial lavage culture", :description => "Positive bronchial lavage culture >= 1000 CFUs", :order => 1)
    Question.create(:guideline_step_id => pneum_step.id, :code => "high_bronch_lavage_cfus", :display => "Positive bronchial lavage culture >= 1000 CFUs", :question_type => "choice", :constraints => "YesNo")
  end

  def down
    delete_record("high_bronch_lavage_cfus", "RESPIRATORY_PNEUMONIA")
  end

  def delete_record question_code, guideline_code
    Question.find_all_by_code(question_code).last.delete
    guideline = Guideline.find_by_code(guideline_code)
    GuidelineStep.find_all_by_guideline_id(guideline.id).each { |x| x.delete }
    guideline.delete
  end
end
