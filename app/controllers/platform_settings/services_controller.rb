# frozen_string_literal: true

class PlatformSettings::ServicesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformService, "description asc")

    @pagy, @platform_services = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformServiceRepository.new(current_user)
  end

  def set_title
    @title = "Platform Services"
  end
end
