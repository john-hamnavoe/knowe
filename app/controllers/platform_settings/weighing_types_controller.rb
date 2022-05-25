# frozen_string_literal: true

class PlatformSettings::WeighingTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_weighing_types_from_platform

  def index
    @query, page = ransack_query(PlatformWeighingType, "description asc")

    @pagy, @platform_weighing_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_weighing_types_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Weighing Types are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformWeighingTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Weighing Types"
  end
end
