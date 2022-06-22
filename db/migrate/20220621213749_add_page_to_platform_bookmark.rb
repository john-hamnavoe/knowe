class AddPageToPlatformBookmark < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_bookmarks, :page, :integer
  end
end
