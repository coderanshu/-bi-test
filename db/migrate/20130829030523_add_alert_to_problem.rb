class AddAlertToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :alert_id, :integer
  end
end
