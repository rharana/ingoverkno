class AddStatusToInstances < ActiveRecord::Migration[6.1]
  def change
    add_column :instances, :status, :integer, default: 1, null: false
  end
end
