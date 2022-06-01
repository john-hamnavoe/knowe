# frozen_string_literal: true

class PlatformSettings::CurrenciesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCurrency, "description asc")

    @pagy, @platform_currencies = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformCurrencyRepository.new(current_user)
  end

  def set_title
    @title = "Platform Currencies"
  end
end
