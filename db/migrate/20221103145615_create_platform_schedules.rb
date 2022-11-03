class CreatePlatformSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_schedules do |t|
      t.date :scheduled_date
      t.boolean :is_completed, default: false
      t.boolean :is_container_schedule, default: false
      t.boolean :is_for_vehicle, default: false
      t.boolean :is_manifest_completed, default: false
      t.boolean :is_manifest_exported, default: false
      t.boolean :is_manifest_exported_failed, default: false
      t.text :notes
      t.string :description
      t.datetime :leave_yard_time
      t.datetime :return_yard_time
      t.uuid :related_vehicle_guid
      t.uuid :related_user_driver_guid
      t.references :platform_vehicle, null: true, foreign_key: true
      t.references :platform_company_outlet, null: false, foreign_key: true


      t.references :project, null: false, foreign_key: true
      t.uuid :guid
      t.text :last_response_body
      t.integer :last_response_code

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_schedules_on_guid_project"      
    end
  end
end
