class CreatePlatformCompanyOutlets < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_company_outlets do |t|
      t.references :platform_company, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.string :abbreviated_description
      t.boolean :is_deleted
      t.string :vat_registration_number
      t.string :analysis_code
      t.uuid :guid
      t.uuid :location_guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_company_outlets_on_guid_project"
    end
  end
end
