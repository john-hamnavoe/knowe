class CreatePlatformPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_posts do |t|
      t.references :project, null: false, foreign_key: true
      t.string :class_name
      t.integer :position
      t.datetime :last_request
      t.string :last_response_code
      t.integer :rows

      t.timestamps
    end
  end
end
