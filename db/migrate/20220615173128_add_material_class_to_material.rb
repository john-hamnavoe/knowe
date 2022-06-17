class AddMaterialClassToMaterial < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_materials, :material_class_guid, :uuid
    add_column :platform_materials, :material_class_description, :string
  end
end
