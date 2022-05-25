# frozen_string_literal: true

class PlatformSettings::PaymentTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_payment_types_from_platform

  def index
    @query, page = ransack_query(PlatformPaymentType, "description asc")

    @pagy, @platform_payment_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_payment_types_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "PaymentTypes are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformPaymentTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Payment Types"
  end
end
