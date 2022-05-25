# frozen_string_literal: true

class PlatformSettings::PrioritiesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_priorities_from_platform

  def index
    @query, page = ransack_query(PlatformPriority, "description asc")

    @pagy, @platform_priorities = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_priorities_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Priorities are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformPriorityRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Priorities"
  end
end
