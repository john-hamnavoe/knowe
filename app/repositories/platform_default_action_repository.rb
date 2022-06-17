# frozen_string_literal: true

class PlatformDefaultActionRepository < ApplicationRepository
  def all(args = {}, order_by = "platform_service_description", direction = "asc")
    query = PlatformDefaultAction.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformDefaultAction.find_by(id: id, project: project)
  end

  def load_by_guid(guid)
    PlatformDefaultAction.find_by(guid: guid, project: project)
  end

  def import(records)
    PlatformDefaultAction.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_action_guid, :platform_action_description, :platform_service_guid, :platform_service_description, 
      :platform_vat_guid, :platform_vat_description, :platform_pricing_basis_guid, :platform_pricing_basis_description, 
      :platform_uom_guid, :platform_uom_description, :platform_material_class_guid, :platform_material_class_description ] }, returning: :guid
  end
end
