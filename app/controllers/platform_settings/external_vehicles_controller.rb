# frozen_string_literal: true

class PlatformSettings::ExternalVehiclesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_external_vehicles_from_platform

  def index
    @query, page = ransack_query(PlatformExternalVehicle, "description asc")

    @pagy, @platform_external_vehicles = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_external_vehicles_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "ExternalVehicles are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformExternalVehicleRepository.new(current_user)
  end

  def set_title
    @title = "Platform External Vehicles"
  end
end
