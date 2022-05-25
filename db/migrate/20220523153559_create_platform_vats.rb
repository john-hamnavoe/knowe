class CreatePlatformVats < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_vats do |t|
      t.uuid :guid
      t.string :description
      t.decimal :rate, precision: 18, scale: 4
      t.boolean :is_deleted
      t.references :project, null: false, foreign_key: true


      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_vats_on_guid_project"
    end
  end
end
