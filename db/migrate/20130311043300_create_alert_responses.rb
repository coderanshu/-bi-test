class CreateAlertResponses < ActiveRecord::Migration
  def change
    create_table :alert_responses do |t|
      t.integer :alert_id
      t.integer :user_id
      t.integer :type

      t.timestamps
    end
  end
end
