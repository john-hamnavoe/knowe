class CreatePlatformDefaultActions < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_default_actions do |t|
      t.references :project, null: false, foreign_key: true
      t.uuid :platform_action_guid
      t.string :platform_action_description
      t.uuid :platform_service_guid
      t.string :platform_service_description
      t.uuid :platform_vat_guid
      t.string :platform_vat_description
      t.uuid :platform_pricing_basis_guid
      t.string :platform_pricing_basis_description
      t.uuid :platform_uom_guid
      t.string :platform_uom_description
      t.uuid :platform_material_class_guid
      t.string :platform_material_class_description
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_default_actions_on_guid_project"
    end
  end
end
