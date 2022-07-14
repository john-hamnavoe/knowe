# frozen_string_literal: true

class PlatformSettings::AccountingPeriodsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformAccountingPeriod, "description asc")

    @pagy, @platform_accounting_periods = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformAccountingPeriodRepository.new(current_user)
  end

  def set_title
    @title = "Platform Accounting Periods"
  end
end
