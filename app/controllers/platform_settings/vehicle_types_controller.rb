# frozen_string_literal: true

class PlatformSettings::VehicleTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformVehicleType, "description asc")

    @pagy, @platform_vehicle_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformVehicleTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Vehicle Types"
  end
end
