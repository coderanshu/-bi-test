class AddStatusToGuidelineStep < ActiveRecord::Migration
  def change
    add_column :guideline_steps, :status, :string
  end
end
