class CreatePlatformBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_bookmarks do |t|
      t.references :project, null: false, foreign_key: true
      t.string :table_name
      t.string :until_bookmark
      t.string :cursor_bookmark

      t.timestamps
    end
  end
end
