# frozen_string_literal: true

class PlatformOrderRepository < ApplicationRepository
  def all(args, params, order_by, direction)
    query = PlatformOrder.where( project: project).where(args)
    query = query.where("lower(order_number) LIKE :keyword OR lower(customer_order_number) LIKE :keyword", keyword: "%#{params[:keywords].downcase}%") if params && params[:keywords].present?

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformOrder.find_by(guid: guid,  project: project)
  end

  def load_by_order_number(order_number)
    PlatformOrder.find_by(order_number: order_number,  project: project)
  end  

  def import(records)
    PlatformOrder.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_customer_site_id, :platform_company_outlet_id, :platform_service_id, :platform_material_id, :order_number, 
                                                                                                                                :customer_order_number, :ordered_by, :process_from, :valid_until, :notes, :driver_notes, :platform_container_type_id, 
                                                                                                                                :platform_service_agreement_id] }, returning: :guid
  end
end
