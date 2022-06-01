# frozen_string_literal: true

class PlatformSettings::MaterialsController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformMaterial, "description asc")

    @pagy, @platform_materials = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformMaterialRepository.new(current_user)
  end

  def set_title
    @title = "Platform Materials"
  end
end
