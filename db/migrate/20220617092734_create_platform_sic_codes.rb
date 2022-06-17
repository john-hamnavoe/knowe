class CreatePlatformSicCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_sic_codes do |t|
      t.references :project, null: false, foreign_key: true
      t.string :description_2007
      t.string :code_2007
      t.string :description_2003
      t.string :code_2003
      t.boolean :is_deleted

      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_sic_codes_on_guid_project"
    end
  end
end
