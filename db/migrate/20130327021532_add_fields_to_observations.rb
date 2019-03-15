class AddFieldsToObservations < ActiveRecord::Migration
  def change
    add_column :observations, :code_system, :string
    add_column :observations, :observed_on, :datetime
  end
end
