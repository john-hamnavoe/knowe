# frozen_string_literal: true

class PlatformSettings::VehiclesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformVehicle, "registration_no asc")

    @pagy, @platform_vehicles = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformVehicleRepository.new(current_user)
  end

  def set_title
    @title = "Platform Vehicles"
  end
end
