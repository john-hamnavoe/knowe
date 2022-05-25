# frozen_string_literal: true

class PlatformSettings::ContainerStatusesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformContainerStatus, "description asc")

    @pagy, @platform_container_statuses = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformContainerStatusRepository.new(current_user)
  end

  def set_title
    @title = "Platform Container Statuses"
  end
end
