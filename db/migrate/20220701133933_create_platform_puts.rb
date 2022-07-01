class CreatePlatformPuts < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_puts do |t|
      t.references :project, null: false, foreign_key: true
      t.string :class_name
      t.integer :last_response_code
      t.text :last_response_body
      t.uuid :guid
      t.integer :failed_count, default: 0

      t.timestamps
    end
  end
end
