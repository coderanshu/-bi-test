class AddDetailsToPatientGuidelineAction < ActiveRecord::Migration
  def change
    add_column :patient_guideline_actions, :details, :text
  end
end
