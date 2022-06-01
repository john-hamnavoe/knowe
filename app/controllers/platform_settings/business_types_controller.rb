# frozen_string_literal: true

class PlatformSettings::BusinessTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformBusinessType, "description asc")

    @pagy, @platform_business_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformBusinessTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Business Types"
  end
end
