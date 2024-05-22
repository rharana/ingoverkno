class CreateInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :instances do |t|
      t.string :name
      t.boolean :multi_tenant
      t.integer :port
      t.string :population
      t.string :province
      t.string :banner_url
      t.string :logo_url
      t.integer :status

      t.timestamps
    end
  end
end
