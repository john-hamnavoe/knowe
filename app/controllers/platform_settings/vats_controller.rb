# frozen_string_literal: true

class PlatformSettings::VatsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformVat, "description asc")

    @pagy, @platform_vats = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformVatRepository.new(current_user)
  end

  def set_title
    @title = "Platform Vat Codes"
  end
end
