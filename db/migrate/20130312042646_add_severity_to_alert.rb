class AddSeverityToAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :severity, :integer
  end
end
