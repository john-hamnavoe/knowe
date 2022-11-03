# frozen_string_literal: true

class PlatformSettings::SchedulesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformSchedule.eager_load(:platform_company_outlet), "scheduled_date desc")

    @pagy, @platform_schedules = pagy(@query.result(distinct: true), page: page)
  end

  def new
    ImportPlatformSchedulesJob.perform_later(current_user, current_user.current_project)
    redirect_to platform_settings_schedules_path, notice: "Schedules Import Queued!"
  end

  def show
    @schedule = repo.load(params[:id])
  end

  private

  def repo
    @repo ||= PlatformScheduleRepository.new(current_user)
  end

  def set_title 
    @title = "Platform Schedules"
  end
end
