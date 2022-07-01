# frozen_string_literal: true

class PlatformPutRepository < ApplicationRepository
  def all(args = {}, order_by = "created_at", direction = "asc")
    query = PlatformPut.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def unsent(allowed_failed_attempts = 0)
    query = PlatformPut.where(project: project)
    query = query.where("failed_count <= ?", allowed_failed_attempts)
    query = query.where("last_response_code IS NULL OR last_response_code != 200")
    query.order(created_at: :asc)
  end

  def create(params)
    put = PlatformPut.new(params)
    put.project = project
    put.save
    put
  end

  def update(id, params)
    put = PlatformPut.find_by(project: project, id: id)
    put&.update(params)
    put
  end

  def update_last_response(id, response_code, response_body)
    put = PlatformPut.find_by(project: project, id: id)
    return nil unless put

    failed_count = put.failed_count 
    failed_count = failed_count + 1 unless response_code == 200

    put.update(last_response_code: response_code, last_response_body: response_body, failed_count: failed_count)
    put
  end

  def load(id)
    PlatformPut.find_by(project: project, id: id)
  end
end
