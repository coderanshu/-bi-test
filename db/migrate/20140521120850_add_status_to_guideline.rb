class AddStatusToGuideline < ActiveRecord::Migration
  def change
    add_column :guidelines, :status, :string
  end
end
