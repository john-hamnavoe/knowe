class CreatePlatformContractStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_contract_statuses do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.boolean :is_deleted
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_contract_status_on_guid_project"
    end
  end
end
