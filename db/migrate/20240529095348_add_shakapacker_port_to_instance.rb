class AddShakapackerPortToInstance < ActiveRecord::Migration[6.1]
  def change
    add_column :instances, :shakapacker_port, :integer
  end
end
