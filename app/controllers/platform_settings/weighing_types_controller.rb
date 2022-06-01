# frozen_string_literal: true

class PlatformSettings::WeighingTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformWeighingType, "description asc")

    @pagy, @platform_weighing_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformWeighingTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Weighing Types"
  end
end
