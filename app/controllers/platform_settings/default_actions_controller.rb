# frozen_string_literal: true

class PlatformSettings::DefaultActionsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformDefaultAction, "platform_service_description asc")

    @pagy, @platform_default_actions = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformDefaultActionRepository.new(current_user)
  end

  def set_title
    @title = "Platform Default Actions"
  end
end
