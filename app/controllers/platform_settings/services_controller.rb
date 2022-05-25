# frozen_string_literal: true

class PlatformSettings::ServicesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_services_from_platform

  def index
    @query, page = ransack_query(PlatformService, "description asc")

    @pagy, @platform_services = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_services_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Services are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformServiceRepository.new(current_user)
  end

  def set_title
    @title = "Platform Services"
  end
end
