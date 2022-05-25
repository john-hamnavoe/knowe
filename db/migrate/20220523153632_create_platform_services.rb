class CreatePlatformServices < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_services do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.boolean :is_deleted
      t.string :external_description
      t.string :short_name
      t.string :analysis_code
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_services_on_guid_project"
    end
  end
end
