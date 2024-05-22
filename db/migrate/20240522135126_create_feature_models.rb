class CreateFeatureModels < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_models do |t|
      t.integer :instance_id
      t.boolean :proposal
      t.boolean :anonimous_proposal
      t.boolean :participatory_text
      t.boolean :policy_proposal
      t.boolean :survey
      t.boolean :sortition
      t.boolean :citizen_forum
      t.boolean :budgeting
      t.boolean :da_support
      t.boolean :km_support
      t.boolean :ir_capability
      t.boolean :transparency
      t.boolean :decision
      t.boolean :meeting
      t.boolean :notification
      t.boolean :debate
      t.boolean :census
      t.boolean :delegation

      t.timestamps
    end
  end
end
