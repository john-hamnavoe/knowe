# frozen_string_literal: true

class PlatformWeighingRepository < ApplicationRepository
  def all(args, params, order_by, direction)
    query = PlatformWeighing.where( project: project).where(args)
    query = query.where("lower(ticket_no) LIKE :keyword OR lower(manual_ticket_no) LIKE :keyword", keyword: "%#{params[:keywords].downcase}%") if params && params[:keywords].present?

    query.order(order_by => direction)
  end

  def create(params)
    platform_weighing = PlatformWeighing.new(params)
    platform_weighing.project = project
    platform_weighing.save
    platform_weighing
  end

  def update(id, params)
    platform_weighing = PlatformWeighing.find_by(id: id,  project: project)
    platform_weighing&.update(params)
    platform_weighing
  end

  def load(id)
    PlatformWeighing.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformWeighing.find_by(guid: guid,  project: project)
  end

  def load_by_ticket_no(ticket_no)
    PlatformWeighing.find_by(order_number: ticket_no,  project: project)
  end
end
