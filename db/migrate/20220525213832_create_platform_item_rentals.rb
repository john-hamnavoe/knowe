class CreatePlatformItemRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_item_rentals do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_order, null: false, foreign_key: true
      t.integer :quantity
      t.date :start_date
      t.references :platform_price, null: true, foreign_key: true
      t.references :platform_action, null: true, foreign_key: true
      t.references :platform_container_type, null: true, foreign_key: true
      t.boolean :is_arrears
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_item_rentals_on_guid_project"
    end
  end
end
