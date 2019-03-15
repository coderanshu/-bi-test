class AddGuidelineIdToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :guideline_id, :integer
  end
end
