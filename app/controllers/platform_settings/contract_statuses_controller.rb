# frozen_string_literal: true

class PlatformSettings::ContractStatusesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_contract_statuses_from_platform

  def index
    @query, page = ransack_query(PlatformContractStatus, "description asc")

    @pagy, @platform_contract_statuses = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_contract_statuses_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "ContractStatuses are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformContractStatusRepository.new(current_user)
  end

  def set_title
    @title = "Platform Contract Statuses"
  end
end
