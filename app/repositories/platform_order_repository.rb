# frozen_string_literal: true

class PlatformOrderRepository < ApplicationRepository
  def all(args={}, order_by="order_number", direction="desc")
    query = PlatformOrder.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformOrder.find_by(guid: guid,  project: project)
  end

  def load_by_order_number(order_number)
    PlatformOrder.find_by(order_number: order_number,  project: project)
  end

  def create(params)
    platform_order = PlatformOrder.new(params)

    platform_order.project = project
    platform_order.platform_order_items.each do |order_item|
      order_item.project = project
    end
    platform_order.save
    platform_order
  end    

  def import(records)
    PlatformOrder.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_customer_site_id, :platform_company_outlet_id, :platform_service_id, :platform_material_id, :order_number, 
                                                                                                              :customer_order_number, :ordered_by, :process_from, :valid_until, :notes, :driver_notes, :platform_container_type_id, 
                                                                                                              :platform_service_agreement_id, :related_order_combination_grouping_guid, :related_service_agreement_guid] }, returning: :guid
  end
end
