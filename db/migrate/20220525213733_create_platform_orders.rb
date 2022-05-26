class CreatePlatformOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_orders do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_customer_site, null: false, foreign_key: true
      t.references :platform_service, null: false, foreign_key: true
      t.references :platform_material, null: false, foreign_key: true
      t.references :platform_company_outlet, null: false, foreign_key: true
      t.references :platform_container_type, null: true, foreign_key: true
      t.references :platform_service_agreement, null: true, foreign_key: true
      t.references :platform_priority, null: true, foreign_key: true
      t.string :order_number
      t.string :customer_order_number
      t.string :ordered_by
      t.date :process_from
      t.date :valid_until
      t.text :notes
      t.text :driver_notes
      t.boolean :is_customer_owned_equipment, default: false
      t.uuid :related_order_combination_grouping_guid

      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_orders_on_guid_project"
    end
  end
end
