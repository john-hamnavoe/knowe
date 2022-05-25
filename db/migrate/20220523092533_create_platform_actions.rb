class CreatePlatformActions < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_actions do |t|
      t.references :project, null: false, foreign_key: true
      t.uuid :guid
      t.string :description
      t.string :analysis_code
      t.boolean :is_deleted
      t.string :short_action
      t.decimal :equivalent_haul, precision: 18, scale: 4

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_actions_on_guid_project"
    end
  end
end
