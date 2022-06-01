# frozen_string_literal: true

class PlatformSettings::RouteTemplatesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformRouteTemplate, "route_no asc")

    @pagy, @platform_route_templates = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformRouteTemplateRepository.new(current_user)
  end

  def set_title
    @title = "Platform Route Templates"
  end
end
