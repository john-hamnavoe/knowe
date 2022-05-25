# frozen_string_literal: true

class PlatformSettings::PaymentPointsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_payment_points_from_platform

  def index
    @query, page = ransack_query(PlatformPaymentPoint, "description asc")

    @pagy, @platform_payment_points = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_payment_points_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "PaymentPoints are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformPaymentPointRepository.new(current_user)
  end

  def set_title
    @title = "Platform Payment Points"
  end
end
