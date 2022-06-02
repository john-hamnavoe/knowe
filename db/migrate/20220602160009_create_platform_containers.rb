class CreatePlatformContainers < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_containers do |t|
      t.references :project, null: false, foreign_key: true
      t.string :tag
      t.string :serial_no
      t.string :note
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.boolean :is_stoplisted
      t.boolean :is_commercial
      t.references :platform_container_status, null: true, foreign_key: true
      t.references :platform_container_type, null: false, foreign_key: true
      t.references :platform_company_outlet, null: true, foreign_key: true
      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_containers_on_guid_project"
    end
  end
end
