class CreatePlatformLiftEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_lift_events do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_order_item, null: true, foreign_key: true
      t.decimal :charge_weight
      t.decimal :net_weight
      t.decimal :weight
      t.integer :quantity_collected
      t.string :vehicle_code
      t.string :information_text
      t.string :lift_text
      t.string :problem_text
      t.string :tag
      t.date :collection_date
      t.datetime :collection_time_stamp
      t.uuid :related_route_guid
      t.uuid :related_route_visit_guid
      t.uuid :related_site_order_container_guid
      t.boolean :is_deleted
      t.boolean :is_collected
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_lift_events_on_guid_project"
    end
  end
end
