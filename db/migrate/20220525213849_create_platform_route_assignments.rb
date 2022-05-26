class CreatePlatformRouteAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_route_assignments do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_order, null: false, foreign_key: true
      t.references :platform_action, null: true, foreign_key: true
      t.references :platform_pickup_interval, null: true, foreign_key: true
      t.references :platform_day_of_week, null: true, foreign_key: true
      t.references :platform_container_type, null: true, foreign_key: true
      t.references :platform_route_template, null: true, foreign_key: true
      t.integer :position
      t.date :start_date
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_route_assignments_on_guid_project"
    end
  end
end
