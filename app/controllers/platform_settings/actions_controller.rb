# frozen_string_literal: true

class PlatformSettings::ActionsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title
  before_action :reload_actions_from_platform

  def index
    @query, page = ransack_query(PlatformAction, "description asc")

    @pagy, @platform_actions = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_actions_from_platform
    return if repo.all({}).count.positive?

    flash[:notice] = "Actions are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformActionRepository.new(current_user)
  end

  def set_title
    @title = "Platform Actions"
  end
end
