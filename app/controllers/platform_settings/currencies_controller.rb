# frozen_string_literal: true

class PlatformSettings::CurrenciesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_currencies_from_platform

  def index
    @query, page = ransack_query(PlatformCurrency, "description asc")

    @pagy, @platform_currencies = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_currencies_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "Currencies are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformCurrencyRepository.new(current_user)
  end

  def set_title
    @title = "Platform Currencies"
  end
end
