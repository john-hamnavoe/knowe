# frozen_string_literal: true

class PlatformSettings::VatsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_vats_from_platform

  def index
    @query, page = ransack_query(PlatformVat, "description asc")

    @pagy, @platform_vats = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_vats_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Vats are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformVatRepository.new(current_user)
  end

  def set_title
    @title = "Platform Vat Codes"
  end
end
