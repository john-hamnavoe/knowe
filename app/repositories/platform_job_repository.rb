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

  def import(records)
    PlatformJob.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:delete_route_assignments_on_completion, :in_progress, :is_adhoc, :is_completed, :is_confirmed, :is_external_transport, :is_financially_confirmed,   
                                                                                                            :is_hazardous_paperwork_complete, :is_scheduled_transfer, :is_warranty, :related_site_order_guid, :platform_action_id, :platform_company_outlet_id,
                                                                                                            :platform_order_id, :platform_container_type_id, :platform_material_id, :platform_vat_id, :platform_order_item_id,
                                                                                                            :customer_order_no, :date_required, :ticket_no, :hazardous_load_reference, :manual_ticket_no, :notes, :po_number,:quantity,
                                                                                                            :related_location_destination_guid, :related_schedule_guid, :platform_schedule_id] }, returning: :guid

    build_order_links
  end

  private

  def build_order_links
    ActiveRecord::Base.connection.exec_update(<<-EOQ)
    UPDATE platform_jobs
        SET platform_order_id = platform_orders.id
      FROM platform_orders
      WHERE platform_jobs.related_site_order_guid = platform_orders.guid AND
            platform_jobs.project_id = platform_orders.project_id AND
            platform_jobs.platform_order_id IS NULL
    EOQ
  end
end
