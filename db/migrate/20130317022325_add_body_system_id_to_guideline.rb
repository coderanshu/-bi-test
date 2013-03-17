class AddBodySystemIdToGuideline < ActiveRecord::Migration
  def change
    add_column :guidelines, :body_system_id, :integer
  end
end
