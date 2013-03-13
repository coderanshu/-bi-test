class AddFieldsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :status, :integer
    add_column :alerts, :acknowledged_id, :integer
    add_column :alerts, :acknowledged_on, :datetime
    add_column :alerts, :expires_on, :datetime
    add_column :alerts, :action_on_expire, :integer
  end
end
