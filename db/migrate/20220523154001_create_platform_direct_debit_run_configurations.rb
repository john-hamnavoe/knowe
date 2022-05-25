class CreatePlatformDirectDebitRunConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_direct_debit_run_configurations do |t|
      t.references :project, null: false, foreign_key: true
      t.string :description
      t.boolean :is_deleted
      t.uuid :guid

      t.timestamps

      # rails generated index name too long     
      t.index [:guid, :project_id], unique: true, name: "index_direct_debit_configuration_on_guid_project"
    end
  end
end
