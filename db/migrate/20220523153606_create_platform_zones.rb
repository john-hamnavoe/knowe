class CreatePlatformZones < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_zones do |t|
      t.uuid :guid
      t.string :description
      t.references :project, null: false, foreign_key: true


      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_zones_on_guid_project"
    end
  end
end
