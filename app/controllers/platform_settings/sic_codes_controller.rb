# frozen_string_literal: true

class PlatformSettings::SicCodesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformSicCode, "code_2007 asc")

    @pagy, @platform_sic_codes = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformSicCodeRepository.new(current_user)
  end

  def set_title
    @title = "Platform SIC Codes"
  end
end
