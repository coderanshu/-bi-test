require 'guideline'
require 'guideline_step'
require 'question'

class UpdateCardiacGuidelines < ActiveRecord::Migration
  def up
    # 33 - Hypertension, malignant
    htn = Guideline.create(:name => "Hypertension, Malignant", :code => "CARDIAC_HYPERTENSION",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 3)
    htn_step = GuidelineStep.create(:guideline_id => htn.id, :name => "Two systolic BP >200", :description => "Systolic BP above threshold two or more times", :order => 1)
    Question.create(:guideline_step_id => htn_step.id, :code => "two_high_systolic_bp", :display => "Two systolic BP >200", :question_type => "choice", :constraints => "YesNo")

    # 34 - Tachycardia
    tach = Guideline.create(:name => "Tachycardia", :code => "CARDIAC_TACHYCARDIA",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 3)
    tach_step = GuidelineStep.create(:guideline_id => tach.id, :name => "High HR", :description => "Two readings in an hour with heart rate >150", :order => 1)
    Question.create(:guideline_step_id => tach_step.id, :code => "two_high_heart_rate", :display => "Two HR >150 in the past hour", :question_type => "choice", :constraints => "YesNo")

    # 35 - Hypotension
    hotn = Guideline.create(:name => "Hypotension", :code => "CARDIAC_HYPOTENSION",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 3)
    hotn_step = GuidelineStep.create(:guideline_id => hotn.id, :name => "Two systolic BP <90", :description => "Systolic BP below threshold two or more times", :order => 1)
    Question.create(:guideline_step_id => hotn_step.id, :code => "two_low_systolic_bp", :display => "Two systolic BP <90", :question_type => "choice", :constraints => "YesNo")

    # 36 - Bradycardia
    brad = Guideline.create(:name => "Bradycardia", :code => "CARDIAC_BRADYCARDIA",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 3)
    brad_step = GuidelineStep.create(:guideline_id => brad.id, :name => "Low HR", :description => "Two readings in an hour with heart rate <40", :order => 1)
    Question.create(:guideline_step_id => brad_step.id, :code => "two_low_heart_rate", :display => "Two HR <40 in the past hour", :question_type => "choice", :constraints => "YesNo")

    # 37 - Weight change
    weight = Guideline.create(:name => "Weight change", :code => "CARDIAC_WEIGHT_CHANGE",
      :organization => "Bedside Intelligence",
      :url => "", :description => "", :body_system_id => 3)
    weight_step = GuidelineStep.create(:guideline_id => weight.id, :name => "Significant weight change", :description => "Loss of weight >= 10kg since admission", :order => 1)
    Question.create(:guideline_step_id => weight_step.id, :code => "weight_change", :display => "Loss of weight >= 10kg since admission", :question_type => "choice", :constraints => "YesNo")
  end

  def down
    delete_record("two_low_heart_rate", "CARDIAC_BRADYCARDIA")
    delete_record("two_low_systolic_bp", "CARDIAC_HYPOTENSION")
    delete_record("two_high_heart_rate", "CARDIAC_TACHYCARDIA")
    delete_record("two_high_systolic_bp", "CARDIAC_HYPERTENSION")
    delete_record("weight_change", "CARDIAC_WEIGHT_CHANGE")
  end

  def delete_record question_code, guideline_code
    Question.find_all_by_code(question_code).last.delete
    guideline = Guideline.find_by_code(guideline_code)
    GuidelineStep.find_all_by_guideline_id(guideline.id).each { |x| x.delete }
    guideline.delete
  end
end
