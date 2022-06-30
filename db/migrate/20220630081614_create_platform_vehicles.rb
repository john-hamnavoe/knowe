class CreatePlatformVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_vehicles do |t|
      t.references :project, null: false, foreign_key: true
      t.string :registration_no
      t.string :vehicle_code
      t.references :platform_company_outlet, null: true, foreign_key: true
      t.references :platform_vehicle_type, null: true, foreign_key: true
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_vehicles_on_guid_project"
    end
  end
end
