# frozen_string_literal: true

class PlatformSettings::BusinessTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title
  before_action :reload_business_types_from_platform

  def index
    @query, page = ransack_query(PlatformBusinessType, "description asc")

    @pagy, @platform_business_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_business_types_from_platform
    return if repo.all.count.positive?

    flash[:notice] = "BusinessTypes are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformBusinessTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Business Types"
  end
end
