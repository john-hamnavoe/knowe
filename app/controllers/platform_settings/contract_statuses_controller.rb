# frozen_string_literal: true

class PlatformSettings::ContractStatusesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformContractStatus, "description asc")

    @pagy, @platform_contract_statuses = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformContractStatusRepository.new(current_user)
  end

  def set_title
    @title = "Platform Contract Statuses"
  end
end
