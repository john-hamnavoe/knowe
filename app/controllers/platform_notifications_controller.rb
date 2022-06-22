# frozen_string_literal: true

class PlatformNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformNotification, "generated_time_stamp asc")

    @pagy, @platform_notifications = pagy(@query.result(distinct: true), page: page)
  end

  def new
    ImportPlatformNotificationsJob.perform_later(current_user, current_user.current_project)
    redirect_to platform_notifications_path, notice: "Notification Import Queued!"
  end

  private

  def set_title
    @title = "Notifications"
  end

  def repo
    @repo ||= PlatformNotificationRepository.new(current_user)
  end
end
