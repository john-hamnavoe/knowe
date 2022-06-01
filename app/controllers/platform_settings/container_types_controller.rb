# frozen_string_literal: true

class PlatformSettings::ContainerTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformContainerType, "description asc")

    @pagy, @platform_container_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformContainerTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Container Types"
  end
end
