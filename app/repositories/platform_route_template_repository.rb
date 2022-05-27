# frozen_string_literal: true

class PlatformRouteTemplateRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformRouteTemplate.eager_load(:platform_company_outlet).where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformRouteTemplate.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformRouteTemplate.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_company_outlet_id, :description, :route_no, :is_deleted, :next_planned_date] }, returning: :guid
  end
end
