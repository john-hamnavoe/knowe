# frozen_string_literal: true

class PlatformRouteTemplateAdapter < ApplicationAdapter
  def fetch
    import_all_route_templates(bookmark_repo.find(PlatformBookmark::ROUTE_TEMPLATE))
  end

  private

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
  end

  def import_all_route_templates(bookmark)
    load_standing_data
    records = []

    response = query_changes("integrator/erp/transport/routeTemplates/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
    records += route_templates_from_response(response.data) if response.success?

    until response.cursor.nil?
      response = query_changes("integrator/erp/transport/routeTemplates/changes", nil, response.cursor)
      records += route_templates_from_response(response.data) if response.success?
    end

    PlatformRouteTemplateRepository.new(nil, project).import(records)

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformRouteTemplate", response.code)
  end

  def route_templates_from_response(response_data)
    records = []
    response_data[:resource].each do |route_template|
      company_outlet_id = @company_outlets.find { |c| c.guid == route_template[:resource][:CompanyOutletListItem][:Guid] }&.id
      records << { project_id: project.id,
                   guid: route_template[:resource][:GUID],
                   description: route_template[:resource][:Description],
                   route_no: route_template[:resource][:RouteNo],
                   is_deleted: route_template[:resource][:IsDeleted],
                   next_planned_date: route_template[:resource][:NextPlannedDate]&.to_date,
                   platform_company_outlet_id: company_outlet_id }
    end
    records
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
