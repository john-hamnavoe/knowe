class CreatePlatformCustomerSites < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_customer_sites do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.string :reference
      t.string :unqiue_customer_site_code
      t.references :platform_customer, null: false, foreign_key: true
      t.references :platform_company_outlet, null: false, foreign_key: true
      t.references :platform_customer_site_state, null: true, foreign_key: true, index: false
      t.references :platform_zone, null: true, foreign_key: true
      t.references :platform_location, null: true, foreign_key: true
      t.references :platform_invoice_location, null: true, foreign_key: { to_table: :platform_locations }
      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid
      t.uuid :location_guid
      t.uuid :location_invoice_guid

      t.timestamps

      # rails generated index name too long
      t.index [:platform_customer_site_state_id], name: "index_platform_customer_sites_on_platform_customer_site_state"
      t.index [:guid, :project_id], unique: true, name: "index_platform_customer_sites_on_guid_project"
    end
  end
end
