class CreatePlatformContainerTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_container_types do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.boolean :is_deleted
      t.string :external_description
      t.string :short_name
      t.string :analysis_code
      t.decimal :size, precision: 18, scale: 4
      t.decimal :tare_weight, precision: 18, scale: 4
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_container_types_on_guid_project"
    end
  end
end
