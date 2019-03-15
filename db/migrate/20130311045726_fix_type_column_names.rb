class FixTypeColumnNames < ActiveRecord::Migration
  def up
    rename_column :alerts, :type, :alert_type
    rename_column :alert_responses, :type, :response_type
    rename_column :locations, :type, :location_type
  end

  def down
    rename_column :alerts, :alert_type, :type
    rename_column :alert_responses, :response_type, :type
    rename_column :locations, :location_type, :type
  end
end
