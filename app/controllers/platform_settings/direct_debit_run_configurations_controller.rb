# frozen_string_literal: true

class PlatformSettings::DirectDebitRunConfigurationsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformDirectDebitRunConfiguration, "description asc")

    @pagy, @platform_direct_debit_run_configurations = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformDirectDebitRunConfigurationRepository.new(current_user)
  end

  def set_title
    @title = "Platform Direct Debit Run Configurations"
  end
end
