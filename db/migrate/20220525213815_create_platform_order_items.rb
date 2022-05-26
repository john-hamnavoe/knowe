class CreatePlatformOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_order_items do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_order, null: false, foreign_key: true
      t.references :platform_container_type, null: false, foreign_key: true
      t.references :platform_container_status, null: false, foreign_key: true
      t.string :tag
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_order_item_on_guid_project"
    end
  end
end
