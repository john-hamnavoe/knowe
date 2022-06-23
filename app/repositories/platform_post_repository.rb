# frozen_string_literal: true

class PlatformPostRepository < ApplicationRepository
  def all(args = {}, order_by = "position", direction = "asc")
    query = PlatformPost.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def create(params)
    post = PlatformPost.new(params)
    post.project = project
    post.save
    post
  end

  def update(id, params)
    post = PlatformPost.find_by(project: project, id: id)
    post&.update(params)
    post
  end

  def update_last_response(class_name, response_code)
    post = PlatformPost.find_by(project: project, class_name: class_name)
    return nil unless post

    row_count = class_name.constantize.where(project: project, guid: nil).count
    post.update(last_response_code: response_code, last_request: Time.zone.now, rows: row_count)
    post
  end

  def update_row_count(class_name)
    post = PlatformPost.find_by(project: project, class_name: class_name)
    return nil unless post

    row_count = class_name.constantize.where(project: project, guid: nil).count
    post.update(rows: row_count)
    post
  end

  def load(id)
    PlatformPost.find_by(project: project, id: id)
  end
end
