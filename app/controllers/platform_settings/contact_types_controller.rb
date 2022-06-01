# frozen_string_literal: true

class PlatformSettings::ContactTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformContactType, "description asc")

    @pagy, @platform_contact_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def repo
    @repo ||= PlatformContactTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Contact Types"
  end
end
