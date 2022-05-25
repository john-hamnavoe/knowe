# frozen_string_literal: true

class PlatformSettings::RouteTemplatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title
  before_action :reload_route_templates_from_platform

  def index
    @query, page = ransack_query(PlatformRouteTemplate, "route_no asc")

    @pagy, @platform_route_templates = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_route_templates_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "RouteTemplates are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformRouteTemplateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Route Templates"
  end
end
