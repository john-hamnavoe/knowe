# frozen_string_literal: true

class PlatformSettings::ZonesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformZone, "description asc")

    @pagy, @platform_zones = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformZoneRepository.new(current_user)
  end

  def set_title
    @title = "Platform Zones"
  end
end
