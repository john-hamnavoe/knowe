class CreatePlatformServiceAgreements < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_service_agreements do |t|
      t.uuid :guid
      t.string :description
      t.references :platform_company_outlet, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true


      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_service_agreements_on_guid_project"
    end
  end
end
