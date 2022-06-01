# frozen_string_literal: true

class PlatformSettings::PaymentPointsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformPaymentPoint, "description asc")

    @pagy, @platform_payment_points = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformPaymentPointRepository.new(current_user)
  end

  def set_title
    @title = "Platform Payment Points"
  end
end
