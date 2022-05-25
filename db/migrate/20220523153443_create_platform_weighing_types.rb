class CreatePlatformWeighingTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_weighing_types do |t|
      t.references :project, null: false, foreign_key: true
      t.uuid :guid
      t.string :description
      t.string :type

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_weighing_types_on_guid_project"
    end
  end
end
