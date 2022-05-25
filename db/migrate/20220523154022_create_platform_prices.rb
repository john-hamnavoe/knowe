class CreatePlatformPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_prices do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.references :platform_service_agreement, null: false, foreign_key: true
      t.references :platform_service, null: true, foreign_key: true
      t.references :platform_action, null: true, foreign_key: true
      t.references :platform_container_type, null: true, foreign_key: true
      t.references :platform_material, null: true, foreign_key: true
      t.decimal :amount, precision: 18, scale: 4
      t.date :effective_from
      t.date :effective_to
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_prices_on_guid_project"
    end
  end
end
