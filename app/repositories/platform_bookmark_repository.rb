# frozen_string_literal: true

class PlatformBookmarkRepository < ApplicationRepository
  def find(table_name)
    PlatformBookmark.find_by(table_name: table_name,  project: project)
  end

  def create_or_update(table_name, until_bookmark, cursor_bookmark)
    PlatformBookmark.find_or_create_by(table_name: table_name,  project: project).update(until_bookmark: until_bookmark, cursor_bookmark: cursor_bookmark)
  end
end
