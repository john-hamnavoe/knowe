# frozen_string_literal: true

class PlatformSettings::PickupIntervalsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_pickup_intervals_from_platform

  def index
    @query, page = ransack_query(PlatformPickupInterval, "description asc")

    @pagy, @platform_pickup_intervals = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_pickup_intervals_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "PickupIntervals are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformPickupIntervalRepository.new(current_user)
  end

  def set_title
    @title = "Platform Pickup Intervals"
  end
end
