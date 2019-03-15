class AddUnitsToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :units, :string
  end
end
