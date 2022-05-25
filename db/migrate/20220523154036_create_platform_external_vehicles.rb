class CreatePlatformExternalVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_external_vehicles do |t|
      t.references :project, null: false, foreign_key: true

      t.string :registration
      t.string :description
      t.uuid :guid

      t.timestamps
      t.index [:guid, :project_id], unique: true, name: "index_platform_external_vehicles_on_guid_project"
    end
  end
end
