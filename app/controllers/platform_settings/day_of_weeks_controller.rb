# frozen_string_literal: true

class PlatformSettings::DayOfWeeksController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformDayOfWeek, "day_of_week asc")

    @pagy, @platform_day_of_weeks = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformDayOfWeekRepository.new(current_user)
  end

  def set_title
    @title = "Platform Days of Weeks"
  end
end
