# frozen_string_literal: true

class PlatformSettings::ExternalVehiclesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformExternalVehicle, "description asc")

    @pagy, @platform_external_vehicles = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformExternalVehicleRepository.new(current_user)
  end

  def set_title
    @title = "Platform External Vehicles"
  end
end
