class AddCodeToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :code, :string
  end
end
