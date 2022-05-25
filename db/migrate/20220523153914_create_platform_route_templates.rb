class CreatePlatformRouteTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_route_templates do |t|
      t.references :project, null: false, foreign_key: true

      t.references :platform_company_outlet, null: false, foreign_key: true
      t.string :description
      t.integer :route_no
      t.boolean :is_deleted
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_route_template_on_guid_project"
    end
  end
end
