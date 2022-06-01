class CreatePlatformSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_settings do |t|
      t.references :project, null: false, foreign_key: true
      t.string :class_name
      t.datetime :last_request
      t.string :last_response_code
      t.integer :position
      t.integer :rows

      t.timestamps
    end
  end
end
