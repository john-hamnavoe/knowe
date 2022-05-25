# frozen_string_literal: true

class PlatformJobRepository < ApplicationRepository
  def all(args, params, order_by, direction)
    query = PlatformJob.where( project: project).where(args)
    query = query.where("lower(ticket_no) LIKE :keyword OR lower(manual_ticket_no) LIKE :keyword", keyword: "%#{params[:keywords].downcase}%") if params && params[:keywords].present?

    query.order(order_by => direction)
  end

  def create(params)
    platform_job = PlatformJob.new(params)
    platform_job.project = project
    platform_job.save
    platform_job
  end

  def update(id, params)
    platform_job = PlatformJob.find_by(id: id,  project: project)
    platform_job&.update(params)
    platform_job
  end

  def load(id)
    PlatformJob.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformJob.find_by(guid: guid,  project: project)
  end

  def load_by_ticket_no(ticket_no)
    PlatformJob.find_by(order_number: ticket_no,  project: project)
  end
end
