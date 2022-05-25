# frozen_string_literal: true

class PlatformSettings::ContactTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_contact_types_from_platform

  def index
    @query, page = ransack_query(PlatformContactType, "description asc")

    @pagy, @platform_contact_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_contact_types_from_platform
    return if repo.all({}).count.positive?

    flash[:notice] = "ContactTypes are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformContactTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Contact Types"
  end
end
