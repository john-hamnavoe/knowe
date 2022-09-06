class CreatePlatformJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_jobs do |t|
      t.boolean :delete_route_assignments_on_completion, default: false
      t.boolean :in_progress, default: false
      t.boolean :is_adhoc, default: false
      t.boolean :is_completed, default: false
      t.boolean :is_confirmed, default: false
      t.boolean :is_external_transport, default: false
      t.boolean :is_financially_confirmed, default: false
      t.boolean :is_hazardous_paperwork_complete, default: false
      t.boolean :is_scheduled_transfer, default: false
      t.boolean :is_warranty, default: false
      t.uuid :related_site_order_guid
      t.references :platform_action, null: false, foreign_key: true
      t.references :platform_company_outlet, null: false, foreign_key: true
      t.references :platform_order, null: true, foreign_key: true
      t.references :platform_container_type, null: true, foreign_key: true
      t.references :platform_material, null: true, foreign_key: true
      t.references :platform_vat, null: true, foreign_key: true
      t.references :platform_order_item, null: true, foreign_key: true      
      t.string :customer_order_no
      t.date :date_required
      t.string :ticket_no
      t.string :hazardous_load_reference
      t.string :manual_ticket_no
      t.string :notes
      t.string :po_number
      t.decimal :quantity, precision: 18, scale: 4
      t.uuid :related_location_destination_guid
      t.uuid :price_override_guid
      t.uuid :related_price_guid
      t.decimal :override_rate, precision: 18, scale: 4      
      t.references :project, null: false, foreign_key: true
      t.uuid :guid
      t.text :last_response_body
      t.integer :last_response_code

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_jobs_on_guid_project"
    end
  end
end
