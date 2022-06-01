# frozen_string_literal: true

class PlatformSettingsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformSetting, "position asc")

    @pagy, @platform_settings = pagy(@query.result(distinct: true), page: page)
  end

  def new
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
    flash[:notice] = "Settings are being fetched!"

    redirect_to platform_settings_path
  end

  private

  def set_title
    @title = "Platform Settings"
  end

  def repo
    @repo ||= PlatformSettingRepository.new(current_user)
  end
end
